#!/usr/bin/env bash
#
# One-off: delete leftover *-dev Docker Hub tags after the develop Hub
# pipeline (trigger-develop / clean-develop) was removed.
#
# Usage (from repo root):
#   ./scripts/delete-dev-tags.sh           # dry-run (list only)
#   ./scripts/delete-dev-tags.sh --apply   # delete matching tags
#
# Credentials: DH_USERNAME and DH_PASSWORD in .env (same as delete-stale.sh).
# Repositories: REPO (space-separated), defaulting to the five Dockershelf shelves.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Prefer already-exported credentials over .env (placeholder .env is common).
_saved_user="${DH_USERNAME:-}"
_saved_pass="${DH_PASSWORD:-}"
if [[ -f .env ]]; then
    set -a
    # shellcheck disable=SC1091
    source .env
    set +a
fi
[[ -n "$_saved_user" ]] && DH_USERNAME="$_saved_user"
[[ -n "$_saved_pass" ]] && DH_PASSWORD="$_saved_pass"
unset _saved_user _saved_pass

USERNAME="${DH_USERNAME:-}"
PASSWORD="${DH_PASSWORD:-}"
REPO="${REPO:-dockershelf/python dockershelf/node dockershelf/go dockershelf/debian dockershelf/latex}"
APPLY=0
HUB_TOKEN=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1" >&2; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1" >&2; }
print_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

is_dev_tag() {
    [[ "$1" =~ -dev(-amd64|-arm64)?$ ]]
}

hub_login() {
    local response token
    response=$(curl -sS -H "Content-Type: application/json" \
        -X POST "https://hub.docker.com/v2/users/login/" \
        -d "$(jq -n --arg u "$USERNAME" --arg p "$PASSWORD" '{username: $u, password: $p}')")
    token=$(echo "$response" | jq -r '.token // empty')
    if [[ -z "$token" || "$token" == "null" ]]; then
        print_error "Docker Hub login failed. Check DH_USERNAME / DH_PASSWORD."
        exit 1
    fi
    HUB_TOKEN="$token"
    print_status "Authenticated to Docker Hub"
}

list_tags() {
    local repo=$1
    local url="https://hub.docker.com/v2/repositories/${repo}/tags?page_size=100"
    local response next

    while [[ -n "$url" && "$url" != "null" ]]; do
        response=$(curl -sS -H "Authorization: Bearer ${HUB_TOKEN}" "$url")
        echo "$response" | jq -r '.results[]?.name // empty'
        next=$(echo "$response" | jq -r '.next // empty')
        url="$next"
    done
}

delete_tag() {
    local repo=$1
    local tag=$2
    local encoded http_code
    encoded=$(jq -rn --arg t "$tag" '$t | @uri')
    http_code=$(curl -sS -o /dev/null -w "%{http_code}" -X DELETE \
        -H "Authorization: Bearer ${HUB_TOKEN}" \
        "https://hub.docker.com/v2/repositories/${repo}/tags/${encoded}/")
    if [[ "$http_code" == "204" || "$http_code" == "202" || "$http_code" == "200" ]]; then
        print_status "Deleted ${repo}:${tag}"
        return 0
    fi
    print_error "Failed to delete ${repo}:${tag} (HTTP ${http_code})"
    return 1
}

show_usage() {
    cat <<EOF
Delete leftover *-dev Docker Hub tags (one-off after dropping the develop Hub pipeline).

Usage: $0 [--apply] [--help]

  (default)   List matching tags; do not delete
  --apply     Delete matching tags
  -h, --help  Show this help

Environment:
  DH_USERNAME   Docker Hub username (required)
  DH_PASSWORD   Docker Hub password or personal access token (required)
  REPO          Space-separated repositories (default: five Dockershelf shelves)

A tag matches if it ends in -dev, -dev-amd64, or -dev-arm64
(covers develop images, extra tags, and -test-dev variants).
EOF
}

while [[ $# -gt 0 ]]; do
    case $1 in
    --apply)
        APPLY=1
        shift
        ;;
    -h | --help)
        show_usage
        exit 0
        ;;
    *)
        print_error "Unknown option: $1"
        show_usage
        exit 1
        ;;
    esac
done

if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
    print_error "Set DH_USERNAME and DH_PASSWORD in .env"
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    print_error "jq is required"
    exit 1
fi

if [[ "$APPLY" -eq 1 ]]; then
    print_warning "Deleting matching *-dev tags from: $REPO"
else
    print_status "Dry-run (pass --apply to delete). Repositories: $REPO"
fi

hub_login

total_found=0
total_deleted=0
total_failed=0

for current_repo in $REPO; do
    print_status "Listing tags in $current_repo"
    found=()
    while IFS= read -r tag; do
        [[ -z "$tag" ]] && continue
        if is_dev_tag "$tag"; then
            found+=("$tag")
        fi
    done < <(list_tags "$current_repo")

    if [[ ${#found[@]} -eq 0 ]]; then
        print_warning "No *-dev tags in $current_repo"
        continue
    fi

    echo "=== $current_repo (${#found[@]} *-dev tag(s)) ==="
    printf '%s\n' "${found[@]}"
    echo ""
    total_found=$((total_found + ${#found[@]}))

    if [[ "$APPLY" -ne 1 ]]; then
        continue
    fi

    for tag in "${found[@]}"; do
        if delete_tag "$current_repo" "$tag"; then
            total_deleted=$((total_deleted + 1))
        else
            total_failed=$((total_failed + 1))
        fi
    done
done

if [[ "$APPLY" -eq 1 ]]; then
    print_status "Done. Found: $total_found, deleted: $total_deleted, failed: $total_failed"
    if [[ "$total_failed" -gt 0 ]]; then
        exit 1
    fi
else
    print_status "Dry-run found $total_found *-dev tag(s). Re-run with --apply to delete."
fi
