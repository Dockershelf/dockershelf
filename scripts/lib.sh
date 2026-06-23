#!/usr/bin/env bash

# Shared release gates for release scripts.
# Managed by rosey-maintainer-tools 0.4.3. Do not edit directly.

RELEASE_CI_WORKFLOW=${RELEASE_CI_WORKFLOW:-push.yml}
RELEASE_CI_TIMEOUT_SECONDS=${RELEASE_CI_TIMEOUT_SECONDS:-2700}
RELEASE_CI_POLL_SECONDS=${RELEASE_CI_POLL_SECONDS:-15}

release_require_command() {
    local command_name=$1

    if ! command -v "$command_name" >/dev/null 2>&1; then
        print_error "Required command is missing: $command_name"
        exit 1
    fi
}

release_require_clean_worktree() {
    if [[ -n "$(git status --porcelain)" ]]; then
        print_error "Working directory is not clean (modified or untracked files present)"
        git status --short >&2
        exit 1
    fi
}

release_check_host_tools() {
    local signing_key
    local tool

    print_step "Checking host release tools"
    for tool in git gh bumpversion gpg; do
        release_require_command "$tool"
    done

    for tool in docker make; do
        release_require_command "$tool"
    done


    if ! git flow version >/dev/null 2>&1; then
        print_error "git-flow is not available (run: git flow version)"
        exit 1
    fi


    if ! docker info >/dev/null 2>&1; then
        print_error "Docker daemon is not running"
        exit 1
    fi


    if ! gh auth status >/dev/null 2>&1; then
        print_error "GitHub CLI is not authenticated (run: gh auth login)"
        exit 1
    fi

    signing_key=$(git config --get user.signingkey || true)
    if [[ -z "$signing_key" ]]; then
        print_error "Git user.signingkey is not configured"
        exit 1
    fi

    if ! gpg --list-secret-keys "$signing_key" >/dev/null 2>&1; then
        print_error "GPG signing key is not available locally: $signing_key"
        exit 1
    fi

    print_step "Host release tools check passed"
}


release_run_preflight() {
    print_step "Running release preflight (Docker)"
    release_require_command docker
    release_require_command make
    make release-preflight
}


release_enable_noninteractive_git() {
    print_step "Configuring git for non-interactive mode"
    git config --local core.editor ":"
    git config --local merge.ours.driver true
    export GIT_MERGE_AUTOEDIT=no
    export GPG_TTY
    GPG_TTY=$(tty) 2>/dev/null || true
}

release_cleanup_noninteractive_git() {
    git config --local --unset core.editor 2>/dev/null || true
    git config --local --unset merge.ours.driver 2>/dev/null || true
}

release_wait_for_branch_ci() {
    local branch_name=$1
    local commit_sha=$2
    local start_time
    local run_id
    local run_url
    local status
    local conclusion

    release_require_command gh
    if ! gh auth status >/dev/null 2>&1; then
        print_error "GitHub CLI is not authenticated; cannot verify release branch CI"
        exit 1
    fi

    print_step "Waiting for GitHub Actions on $branch_name ($commit_sha)"
    start_time=$(date +%s)

    while true; do
        run_id=$(gh run list \
            --workflow "$RELEASE_CI_WORKFLOW" \
            --branch "$branch_name" \
            --commit "$commit_sha" \
            --limit 1 \
            --json databaseId \
            --jq '.[0].databaseId // ""')

        if [[ -n "$run_id" ]]; then
            run_url=$(gh run view "$run_id" --json url --jq '.url')
            print_step "Found CI run $run_id: $run_url"
            if gh run watch "$run_id" --exit-status; then
                print_step "Release branch CI passed"
                return 0
            fi

            status=$(gh run view "$run_id" --json status --jq '.status')
            conclusion=$(gh run view "$run_id" --json conclusion --jq '.conclusion')
            print_error "Release branch CI failed: status=$status conclusion=$conclusion"
            print_error "Run URL: $run_url"
            exit 1
        fi

        if (( $(date +%s) - start_time > RELEASE_CI_TIMEOUT_SECONDS )); then
            print_error "Timed out waiting for GitHub Actions run on $branch_name"
            print_error "Workflow: $RELEASE_CI_WORKFLOW; commit: $commit_sha"
            exit 1
        fi

        sleep "$RELEASE_CI_POLL_SECONDS"
    done
}

release_verify_remote_tag() {
    local version=$1
    local max_retries=${2:-5}
    local retry_delay=${3:-3}
    local attempt

    print_step "Verifying tag was pushed to remote"

    for attempt in $(seq 1 "$max_retries"); do
        if git ls-remote --tags origin | grep -q "refs/tags/$version$"; then
            print_step "Tag $version found on remote"
            return 0
        fi

        if [[ "$attempt" -lt "$max_retries" ]]; then
            print_warning "Tag not found on remote, retrying in ${retry_delay}s... (attempt $attempt/$max_retries)"
            sleep "$retry_delay"
            git push origin master develop --tags
        fi
    done

    print_error "Tag $version was not found on remote after $max_retries attempts"
    print_error "Please verify the push manually: git push origin --tags"
    exit 1
}

release_build_notes() {
    local current_version=$1
    local new_version=$2
    local description_text=""
    local release_content=""
    local repo_slug=""

    if [[ -f "RELEASE_DESCRIPTION.md" ]]; then
        description_text=$(<"RELEASE_DESCRIPTION.md")
    fi

    if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
        repo_slug=$(gh repo view --json owner,name -q '.owner.login + "/" + .name')
    else
        repo_slug=$(git config --get remote.origin.url | sed -E 's#^git@github.com:##; s#^https://github.com/##; s#\.git$##')
    fi

    if [[ -f "HISTORY.md" ]]; then
        release_content=$(awk "/^$new_version \(/ { flag=1; next } flag && /^[0-9]+\.[0-9]+\.[0-9]+ \(/ { exit } flag" HISTORY.md)
        printf '%s\n\n## What'\''s new in %s\n%s\n\nRead [HISTORY](HISTORY.md) for more info.\n\n**Full Changelog**: https://github.com/%s/compare/%s...%s' \
            "$description_text" \
            "$new_version" \
            "$release_content" \
            "$repo_slug" \
            "$current_version" \
            "$new_version"
    else
        printf '%s' "$description_text"
    fi
}

release_create_github_release() {
    local version=$1
    local title=$2
    local notes=$3

    print_step "Publishing GitHub release"
    if ! command -v gh >/dev/null 2>&1; then
        print_warning "GitHub CLI not found, skipping GitHub release creation"
        return 0
    fi

    if ! gh auth status >/dev/null 2>&1; then
        print_warning "GitHub CLI not authenticated. Please run 'gh auth login' first."
        print_warning "You can create the GitHub release manually later."
        return 0
    fi

    if gh release view "$version" >/dev/null 2>&1; then
        print_warning "GitHub release $version already exists, skipping creation"
        return 0
    fi

    print_step "Creating GitHub release $version"
    if gh release create "$version" \
        --title "$title" \
        --notes "$notes" \
        --latest; then
        print_step "GitHub release created successfully!"
    else
        print_warning "Failed to create GitHub release. You can create it manually later."
    fi
}

release_finish_release() {
    local version=$1
    local app_name=$2
    local previous_version

    release_enable_noninteractive_git
    trap release_cleanup_noninteractive_git EXIT

    print_step "Finishing git flow release"
    git flow release finish -s -p -m "Release version $version" "$version"

    print_step "Removing remote release branch"
    git push origin --delete "release/$version" 2>/dev/null || true

    print_step "Pushing master, develop, and tags to origin"
    git push origin master develop --tags

    release_verify_remote_tag "$version"

    previous_version=${PREVIOUS_VERSION:-$(git tag --sort=-v:refname | awk -v version="$version" '$0 != version { print; exit }')}
    release_create_github_release "$version" "$app_name $version" "$(release_build_notes "$previous_version" "$version")"
}

release_read_post_bump_commands() {
    if [[ ! -f .bumpversion.cfg ]]; then
        return 0
    fi

    awk '
        /^\[rosey-maintainer\]/ { in_section=1; next }
        /^\[/ && in_section { exit }
        in_section && /^post_bump_commands[[:space:]]*=/ {
            line = $0
            sub(/^post_bump_commands[[:space:]]*=[[:space:]]*/, "", line)
            if (length(line) > 0) {
                print line
            } else {
                collecting = 1
            }
            next
        }
        collecting && /^[[:space:]]+/ {
            sub(/^[[:space:]]+/, "")
            if (length($0) > 0) {
                print
            }
            next
        }
        collecting && /^[^[:space:]]/ { exit }
    ' .bumpversion.cfg
}

release_run_post_bump_commands() {
    local command

    while IFS= read -r command; do
        [[ -z "$command" ]] && continue
        print_step "Running post-bump command: $command"
        bash -c "$command"
    done < <(release_read_post_bump_commands)
}

release_resolve_branch_version() {
    local branch_prefix=$1
    local current_branch
    local version

    current_branch=$(git branch --show-current)
    version=${VERSION:-${current_branch#${branch_prefix}/}}

    if [[ "$current_branch" != "${branch_prefix}/"* && -z "${VERSION:-}" ]]; then
        print_error "Must run from ${branch_prefix}/<version> or set VERSION=<version>"
        exit 1
    fi

    if ! echo "$version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
        print_error "Version is not valid: $version"
        exit 1
    fi

    printf '%s' "$version"
}
