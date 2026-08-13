#!/bin/bash

# Docker Hub Untagged Image Cleanup Script
# Finds and deletes untagged Docker images from Docker Hub repositories

set -e

source .env

# Configuration
USERNAME=${DH_USERNAME}
PASSWORD=${DH_PASSWORD}
REPO=${REPO:-""}
DOCKER_HUB_COOKIE=${DOCKER_HUB_COOKIE:-""}
MAX_UNTAGGED_LIMIT=${MAX_UNTAGGED_LIMIT:-100}
MAX_PAGINATION_REQUESTS=${MAX_PAGINATION_REQUESTS:-150}
# Prefer indexes/lists so multi-arch tags resolve to the fat manifest, not one platform.
MANIFEST_ACCEPT="application/vnd.oci.image.index.v1+json,application/vnd.docker.distribution.manifest.list.v2+json,application/vnd.oci.image.manifest.v1+json,application/vnd.docker.distribution.manifest.v2+json"

# Token management
CURRENT_TOKEN=""
CURRENT_REPO=""
TOKEN_EXPIRES_AT=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1" >&2
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Function to get bearer token for Registry API
get_token() {
    local repo=$1
    local response=$(curl -s -u "$USERNAME:$PASSWORD" \
        "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$repo:pull,push,delete")

    local token=$(echo "$response" | jq -r .token)
    local expires_in=$(echo "$response" | jq -r .expires_in)

    if [ "$token" = "null" ] || [ -z "$token" ]; then
        print_error "Failed to get authentication token for $repo. Check your credentials."
        exit 1
    fi

    if [ "$expires_in" = "null" ] || [ -z "$expires_in" ]; then
        print_warning "Token expiration time not provided, assuming 300 seconds"
        expires_in=300
    fi

    # Calculate expiration timestamp (current time + expires_in - 30 second buffer)
    local current_time=$(date +%s)
    TOKEN_EXPIRES_AT=$((current_time + expires_in - 30))
    CURRENT_TOKEN="$token"
    CURRENT_REPO="$repo"

    print_status "Got new token for $repo, expires in ${expires_in}s"
}

# Function to list all tags for the repository
list_tags() {
    local token=$1
    local repo=$2

    local tags=$(curl -s -H "Authorization: Bearer $token" \
        "https://registry-1.docker.io/v2/$repo/tags/list" | jq -r '.tags[]?' 2>/dev/null)

    echo "$tags"
}

# Function to get digest for a specific tag
get_digest_for_tag() {
    local token=$1
    local repo=$2
    local tag=$3

    local digest=$(curl -sI -H "Authorization: Bearer $token" \
        -H "Accept: $MANIFEST_ACCEPT" \
        "https://registry-1.docker.io/v2/$repo/manifests/$tag" |
        grep -i docker-content-digest | tr -d '\r' | awk '{print $2}')

    echo "$digest"
}

# Child digests listed by an index/manifest list. Empty for a platform image.
list_child_digests() {
    local token=$1
    local repo=$2
    local digest=$3

    curl -s -H "Authorization: Bearer $token" \
        -H "Accept: $MANIFEST_ACCEPT" \
        "https://registry-1.docker.io/v2/$repo/manifests/$digest" |
        jq -r '.manifests[]?.digest // empty'
}

# Function to check if Docker Hub cookie has expired
check_cookie_expiration() {
    local response="$1"

    # Check for indicators of expired cookie/redirect response
    if echo "$response" | grep -q "SingleFetchRedirect" && echo "$response" | grep -q "/login?returnTo="; then
        print_error "Docker Hub session cookie has expired!"
        print_error "The response indicates you need to log in again."
        print_error ""
        print_error "To get a new cookie:"
        print_error "1. Open Docker Hub in your browser and log in"
        print_error "2. Open Developer Tools (F12)"
        print_error "3. Go to Network tab and refresh the page"
        print_error "4. Click on any request to hub.docker.com"
        print_error "5. In Request Headers, copy the entire 'Cookie:' value"
        print_error "6. Update your .env file with the new DOCKER_HUB_COOKIE value"
        exit 1
    fi
}

# Function to check rate limits and wait if necessary
check_rate_limit() {
    local headers_file=$1
    local request_num=$2

    # Extract rate limit headers
    local limit=$(grep -i "x-ratelimit-limit" "$headers_file" | awk '{print $2}' | tr -d '\r')
    local remaining=$(grep -i "x-ratelimit-remaining" "$headers_file" | awk '{print $2}' | tr -d '\r')
    local reset=$(grep -i "x-ratelimit-reset" "$headers_file" | awk '{print $2}' | tr -d '\r')

    if [ -n "$limit" ] && [ -n "$remaining" ] && [ -n "$reset" ]; then
        echo "Request $request_num: Rate limit status - $remaining/$limit remaining" >&2

        # Check if we're approaching the rate limit (less than 5 requests remaining)
        if [ "$remaining" -le 5 ]; then
            local current_time=$(date +%s)
            local wait_time=$((reset - current_time))

            if [ $wait_time -gt 0 ]; then
                print_warning "Rate limit nearly exhausted ($remaining/$limit remaining)"
                print_warning "Waiting for rate limit reset in $wait_time seconds..."

                # Show countdown
                while [ $wait_time -gt 0 ]; do
                    local minutes=$((wait_time / 60))
                    local seconds=$((wait_time % 60))
                    printf "\rTime remaining: %02d:%02d" $minutes $seconds
                    sleep 1
                    wait_time=$((wait_time - 1))
                done

                echo ""
                print_status "Rate limit reset. Continuing..."
            else
                print_status "Rate limit should have already reset. Continuing..."
            fi
        fi
    else
        echo "Request $request_num: No rate limit headers found" >&2
    fi
}

# Function to get all manifests using Docker Hub's internal API
list_all_manifests() {
    local repo=$1
    local request_num=1
    local all_manifests=""
    local last_key=""

    while true; do
        local response
        local headers_file="/tmp/dockerhub_headers_$$"

        if [ $request_num -eq 1 ]; then
            # First request: GET without pagination
            echo "Request $request_num: Initial GET request" >&2
            response=$(curl -s -D "$headers_file" -H "Cookie: $DOCKER_HUB_COOKIE" \
                -H "X-Requested-With: XMLHttpRequest" \
                -H "Accept: application/json" \
                "https://hub.docker.com/repository/docker/$repo/image-management.data?sortField=last_pushed&sortOrder=asc")
        else
            # Subsequent requests: POST with lastEvaluatedKey
            echo "Request $request_num: POST request with pagination" >&2
            response=$(curl -s -D "$headers_file" -X POST \
                -H "Cookie: $DOCKER_HUB_COOKIE" \
                -H "X-Requested-With: XMLHttpRequest" \
                -H "Accept: application/json" \
                -H "Content-Type: application/x-www-form-urlencoded" \
                --data-raw "intent=paginate&lastEvaluatedKey=$last_key" \
                "https://hub.docker.com/repository/docker/$repo/image-management.data?sortField=last_pushed&sortOrder=asc")
        fi

        # Check if cookie has expired
        check_cookie_expiration "$response"

        # Check rate limits and wait if necessary
        check_rate_limit "$headers_file" "$request_num"

        # Clean up headers file
        rm -f "$headers_file"

        # Extract manifest digests from the flat array response
        local manifests=$(echo "$response" | jq -r '.[] | select(type == "string" and (startswith("sha256:") or startswith("sha1:") or startswith("md5:"))) // empty' 2>/dev/null)

        # Debug: show what we found on this request
        if [ -n "$manifests" ]; then
            echo "Request $request_num: Found $(echo "$manifests" | wc -w) digest(s)" >&2
            all_manifests="$all_manifests $manifests"
        else
            echo "Request $request_num: No digests found" >&2
        fi

        # Check if there's a lastEvaluatedKey for pagination
        local last_key_index=$(echo "$response" | jq -r 'to_entries | map(select(.value == "lastEvaluatedKey")) | .[0].key // empty' 2>/dev/null)
        last_key=""
        if [ -n "$last_key_index" ] && [ "$last_key_index" != "null" ]; then
            # Get the next element after "lastEvaluatedKey"
            last_key=$(echo "$response" | jq -r ".[$((last_key_index + 1))] // empty" 2>/dev/null)
        fi

        if [ -z "$last_key" ] || [ "$last_key" = "null" ]; then
            echo "Request $request_num: No more pages (no lastEvaluatedKey found)" >&2
            break
        else
            echo "Request $request_num: Found lastEvaluatedKey, continuing to next request..." >&2
        fi

        request_num=$((request_num + 1))

        # Safety break to prevent infinite loops
        if [ $request_num -gt $MAX_PAGINATION_REQUESTS ]; then
            echo "Reached maximum requests ($MAX_PAGINATION_REQUESTS). Stopping." >&2
            break
        fi
    done

    echo "$all_manifests" | tr ' ' '\n' | sort | uniq | grep -v '^$'
}

# Function to delete manifest by digest
delete_manifest() {
    local token=$1
    local repo=$2
    local digest=$3

    local temp_response="/tmp/delete_response_$$"
    local response=$(curl -s -w "%{http_code}" -o "$temp_response" -X DELETE \
        -H "Authorization: Bearer $token" \
        "https://registry-1.docker.io/v2/$repo/manifests/$digest")

    local http_code="$response"
    local response_body=$(cat "$temp_response" 2>/dev/null)

    # Clean up temp file
    rm -f "$temp_response"

    if [ "$http_code" = "202" ] || [ "$http_code" = "204" ]; then
        print_status "Successfully deleted manifest: $digest"
        return 0
    fi

    # Platform images still pointed at by an index (tagged or leftover).
    if [ "$http_code" = "403" ] && echo "$response_body" | grep -q "referenced by other images"; then
        return 2
    fi

    print_error "Failed to delete manifest: $digest"
    print_error "HTTP Status Code: $http_code"
    print_error "Repository: $repo"
    print_error "Digest: $digest"
    if [ -n "$response_body" ]; then
        print_error "Response Body: $response_body"
    fi
    print_error "Delete URL: https://registry-1.docker.io/v2/$repo/manifests/$digest"
    return 1
}

# Function to find untagged manifests
find_untagged_manifests() {
    local token=$1
    local repo=$2
    local limit=${3:-0}

    print_status "Getting tagged manifests..."

    # Check token before getting tags
    current_time=$(date +%s)
    if [ $current_time -ge $TOKEN_EXPIRES_AT ]; then
        print_status "Token expired, refreshing before getting tags"
        get_token "$repo"
        token="$CURRENT_TOKEN"
    fi

    local tags=$(list_tags "$token" "$repo")
    local keep_file
    keep_file=$(mktemp)

    if [ -n "$tags" ]; then
        while IFS= read -r tag; do
            if [ -n "$tag" ]; then
                # Check token before each digest request
                current_time=$(date +%s)
                if [ $current_time -ge $TOKEN_EXPIRES_AT ]; then
                    print_status "Token expired, refreshing before getting digest"
                    get_token "$repo"
                    token="$CURRENT_TOKEN"
                fi

                local digest=$(get_digest_for_tag "$token" "$repo" "$tag")
                if [ -n "$digest" ]; then
                    printf '%s\n' "$digest" >>"$keep_file"
                    local children
                    children=$(list_child_digests "$token" "$repo" "$digest")
                    if [ -n "$children" ]; then
                        printf '%s\n' "$children" >>"$keep_file"
                    fi
                fi
            fi
        done <<<"$tags"
    fi

    print_status "Getting all manifests (including untagged)..."
    local all_manifests=$(list_all_manifests "$repo")

    print_status "Finding untagged manifests..."
    local untagged_manifests=""
    local count=0

    while IFS= read -r manifest; do
        if [ -n "$manifest" ]; then
            if ! grep -Fxq "$manifest" "$keep_file" 2>/dev/null; then
                untagged_manifests="$untagged_manifests $manifest"
                count=$((count + 1))

                # Stop if we've reached the limit
                if [ "$limit" -gt 0 ] && [ "$count" -ge "$limit" ]; then
                    print_warning "Reached limit of $limit untagged manifests. There may be more."
                    break
                fi
            fi
        fi
    done <<<"$all_manifests"

    rm -f "$keep_file"
    echo "$untagged_manifests" | tr ' ' '\n' | grep -v '^$'
}

# Function to show usage
show_usage() {
    cat <<EOF
Docker Hub Untagged Image Cleanup Script

Usage: $0 COMMAND

Commands:
    list-untagged       List untagged manifests (digests)
    delete-untagged     Delete all untagged manifests
    -h, --help          Show this help message

Environment Variables:
    DH_USERNAME          Docker Hub username (required)
    DH_PASSWORD          Docker Hub password or personal access token (required)
    DOCKER_HUB_COOKIE    Session cookie from logged-in browser (required)
    REPO                 Space-separated list of repositories (required)
    MAX_UNTAGGED_LIMIT   Maximum number of untagged manifests to list (default: 100)
    MAX_PAGINATION_REQUESTS Maximum number of pagination requests to make (default: 150)

Examples:
    REPO="dockershelf/python" $0 list-untagged
    REPO="dockershelf/python dockershelf/node" $0 delete-untagged
    
    # With custom repositories:
    REPO="dockershelf/python dockershelf/node dockershelf/go" $0 list-untagged

Getting the session cookie:
    1. Open Docker Hub in your browser and log in
    2. Open Developer Tools (F12)
    3. Go to Network tab and refresh the page
    4. Click on any request to hub.docker.com
    5. In Request Headers, copy the entire 'Cookie:' value
    6. Add it to your .env file as DOCKER_HUB_COOKIE="your-cookie-here"

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
        show_usage
        exit 0
        ;;
    list-untagged | delete-untagged)
        COMMAND="$1"
        shift
        ;;
    *)
        print_error "Unknown option: $1"
        show_usage
        exit 1
        ;;
    esac
done

# Validate required parameters
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    print_error "Missing required credentials. Please set DH_USERNAME and DH_PASSWORD in .env file."
    exit 1
fi

if [ -z "$REPO" ]; then
    print_error "Missing required REPO variable. Please set REPO in .env file or as environment variable."
    print_error "Example: REPO=\"dockershelf/python dockershelf/node dockershelf/go\""
    exit 1
fi

if [ -z "$COMMAND" ]; then
    print_error "No command specified."
    show_usage
    exit 1
fi

if [ -z "$DOCKER_HUB_COOKIE" ]; then
    print_error "Docker Hub session cookie is required."
    print_error "Please provide it using -c/--cookie or DOCKER_HUB_COOKIE env var."
    print_error ""
    print_error "To get the cookie:"
    print_error "1. Open Docker Hub in your browser and log in"
    print_error "2. Open Developer Tools (F12)"
    print_error "3. Go to Network tab and refresh the page"
    print_error "4. Click on any request to hub.docker.com"
    print_error "5. In Request Headers, copy the entire 'Cookie:' value"
    exit 1
fi

# Validate limit parameter
if ! [[ "$MAX_UNTAGGED_LIMIT" =~ ^[0-9]+$ ]] || [ "$MAX_UNTAGGED_LIMIT" -lt 1 ]; then
    print_error "Invalid limit value: $MAX_UNTAGGED_LIMIT. Must be a positive integer."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &>/dev/null; then
    print_error "jq is required but not installed. Please install jq first."
    exit 1
fi

# Execute the requested command for each repository
for current_repo in $REPO; do
    print_status "Working with repository: $current_repo"

    # Get initial token for this repository in main shell context
    get_token "$current_repo"

    case $COMMAND in
    list-untagged)
        print_status "Listing untagged manifests (limit: $MAX_UNTAGGED_LIMIT)..."
        untagged=$(find_untagged_manifests "$CURRENT_TOKEN" "$current_repo" "$MAX_UNTAGGED_LIMIT")
        if [ -n "$untagged" ]; then
            echo "=== $current_repo ==="
            echo "$untagged"
            echo ""
            print_status "Found $(echo "$untagged" | wc -w) untagged manifest(s) in $current_repo"
        else
            print_warning "No untagged manifests found in $current_repo."
        fi
        echo ""
        ;;

    delete-untagged)
        # For deletion, get ALL untagged manifests (no limit)
        print_status "Getting complete list of untagged manifests for deletion..."
        untagged=$(find_untagged_manifests "$CURRENT_TOKEN" "$current_repo" 0)

        if [ -n "$untagged" ]; then
            deleted_count=0
            failed_count=0
            total_count=$(echo "$untagged" | wc -w)
            request_num=1

            print_status "Deleting $total_count untagged manifest(s) from $current_repo..."

            retry_list=""
            skipped_count=0

            while IFS= read -r digest; do
                if [ -n "$digest" ]; then
                    current_time=$(date +%s)
                    if [ $current_time -ge $TOKEN_EXPIRES_AT ]; then
                        print_status "Token expired, refreshing before delete operation"
                        get_token "$current_repo"
                    fi

                    delete_manifest "$CURRENT_TOKEN" "$current_repo" "$digest" && rc=0 || rc=$?
                    if [ "$rc" -eq 0 ]; then
                        deleted_count=$((deleted_count + 1))
                    elif [ "$rc" -eq 2 ]; then
                        retry_list="$retry_list $digest"
                    else
                        failed_count=$((failed_count + 1))
                    fi
                    request_num=$((request_num + 1))
                fi
            done <<<"$untagged"

            retry_list=$(echo "$retry_list" | tr ' ' '\n' | grep -v '^$')
            if [ -n "$retry_list" ]; then
                retry_count=$(echo "$retry_list" | wc -w)
                print_status "Retrying $retry_count manifest(s) that were still referenced (after parent indexes)..."
                while IFS= read -r digest; do
                    if [ -n "$digest" ]; then
                        current_time=$(date +%s)
                        if [ $current_time -ge $TOKEN_EXPIRES_AT ]; then
                            print_status "Token expired, refreshing before delete operation"
                            get_token "$current_repo"
                        fi

                        delete_manifest "$CURRENT_TOKEN" "$current_repo" "$digest" && rc=0 || rc=$?
                        if [ "$rc" -eq 0 ]; then
                            deleted_count=$((deleted_count + 1))
                        elif [ "$rc" -eq 2 ]; then
                            print_warning "Still referenced by other images, skipping: $digest"
                            skipped_count=$((skipped_count + 1))
                        else
                            failed_count=$((failed_count + 1))
                        fi
                    fi
                done <<<"$retry_list"
            fi

            print_status "Deletion complete for $current_repo. Deleted: $deleted_count, Skipped (still referenced): $skipped_count, Failed: $failed_count"
        else
            print_warning "No untagged manifests found to delete in $current_repo."
        fi
        echo ""
        ;;
    esac
done

print_status "Operation completed."
