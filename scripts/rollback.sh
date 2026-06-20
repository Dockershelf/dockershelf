#!/usr/bin/env bash
set -euo pipefail

FLOW_TYPE=${1:-release}
VERSION=${VERSION:-}
NON_INTERACTIVE=${NON_INTERACTIVE:-false}
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_step() { echo -e "${GREEN}[UNDO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

source "$SCRIPT_DIR/lib.sh"

if [[ "$FLOW_TYPE" != "release" ]]; then
    print_error "Usage: VERSION=x.y.z $0 [release]"
    exit 1
fi

if [[ -z "$VERSION" ]]; then
    current_branch=$(git branch --show-current 2>/dev/null || true)
    if [[ "$current_branch" == release/* ]]; then
        VERSION=${current_branch#*/}
    fi
fi

if [[ -z "$VERSION" ]] || ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    print_error "Set VERSION=x.y.z or run from release/<version>"
    exit 1
fi

BRANCH_NAME="${FLOW_TYPE}/${VERSION}"
STASHED=false

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

release_require_command git
release_require_command gh

if [[ -n "$(git status --porcelain)" ]]; then
    print_warning "Stashing dirty working tree before rollback"
    git stash push -u -m "rollback-${FLOW_TYPE}-${VERSION}"
    STASHED=true
fi

branch_exists_local=false
branch_exists_remote=false
tag_exists_local=false
tag_exists_remote=false
release_exists=false

if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    branch_exists_local=true
fi

if git ls-remote --heads origin "$BRANCH_NAME" | grep -q .; then
    branch_exists_remote=true
fi

if git show-ref --verify --quiet "refs/tags/$VERSION"; then
    tag_exists_local=true
fi

if git ls-remote --tags origin | grep -q "refs/tags/$VERSION$"; then
    tag_exists_remote=true
fi

if gh release view "$VERSION" >/dev/null 2>&1; then
    release_exists=true
fi

if [[ "$branch_exists_local" == false && "$branch_exists_remote" == false \
    && "$tag_exists_local" == false && "$tag_exists_remote" == false \
    && "$release_exists" == false ]]; then
    print_error "Nothing to undo for ${FLOW_TYPE} $VERSION"
    if [[ "$STASHED" == true ]]; then
        git stash pop || true
    fi
    exit 1
fi

print_step "Rolling back ${FLOW_TYPE} $VERSION"
print_step "Local branch: $branch_exists_local; remote branch: $branch_exists_remote"
print_step "Local tag: $tag_exists_local; remote tag: $tag_exists_remote; GitHub release: $release_exists"

if [[ "$NON_INTERACTIVE" != "true" ]]; then
    read -p "Proceed with rollback for ${FLOW_TYPE} ${VERSION}? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Rollback cancelled"
        if [[ "$STASHED" == true ]]; then
            git stash pop || true
        fi
        exit 1
    fi
fi

rollback_in_progress() {
    print_step "Undoing in-progress release branch $BRANCH_NAME"

    if [[ "$branch_exists_local" == true ]]; then
        if [[ "$(git branch --show-current)" == "$BRANCH_NAME" ]]; then
            git checkout develop
        fi
        git flow release delete "$VERSION" 2>/dev/null || git branch -D "$BRANCH_NAME"
    else
        git checkout develop 2>/dev/null || true
    fi

    if [[ "$branch_exists_remote" == true ]]; then
        git push origin --delete "$BRANCH_NAME" 2>/dev/null || true
    fi

    if [[ "$tag_exists_local" == true ]]; then
        git tag -d "$VERSION" 2>/dev/null || true
    fi
}

rollback_completed() {
    local previous_version
    local merge_commit
    local develop_branch

    previous_version=$(git tag --sort=-v:refname | awk -v version="$VERSION" '$0 != version { print; exit }')
    if [[ -z "$previous_version" ]]; then
        print_error "Cannot find previous version tag to reset master/develop"
        exit 1
    fi

    print_step "Undoing completed release $VERSION (resetting to $previous_version)"

    if [[ "$release_exists" == true ]]; then
        gh release delete "$VERSION" --yes
    fi

    if [[ "$tag_exists_remote" == true ]]; then
        git push origin --delete "refs/tags/$VERSION" 2>/dev/null || true
    fi

    if [[ "$tag_exists_local" == true ]]; then
        git tag -d "$VERSION" 2>/dev/null || true
    fi

    if [[ "$branch_exists_remote" == true ]]; then
        git push origin --delete "$BRANCH_NAME" 2>/dev/null || true
    fi

    if [[ "$branch_exists_local" == true ]]; then
        git branch -D "$BRANCH_NAME" 2>/dev/null || true
    fi

    git checkout master
    git reset --hard "$previous_version"
    git push origin master --force-with-lease

    develop_branch=$(git config --get gitflow.branch.develop || echo develop)
    git checkout "$develop_branch"

    merge_commit=$(git log "$develop_branch" --merges --grep="release $VERSION" -1 --format=%H 2>/dev/null || true)
    if [[ -z "$merge_commit" ]]; then
        merge_commit=$(git log "$develop_branch" --merges --grep="$VERSION" -1 --format=%H 2>/dev/null || true)
    fi

    if [[ -n "$merge_commit" ]]; then
        git reset --hard "${merge_commit}^"
    else
        git reset --hard "$previous_version"
    fi

    git push origin "$develop_branch" --force-with-lease
    git checkout "$develop_branch"
}

if [[ "$tag_exists_remote" == true || "$release_exists" == true ]]; then
    rollback_completed
elif [[ "$branch_exists_local" == true || "$branch_exists_remote" == true ]]; then
    rollback_in_progress
else
    if [[ "$tag_exists_local" == true ]]; then
        git tag -d "$VERSION" 2>/dev/null || true
    fi
    git checkout develop 2>/dev/null || true
fi

if [[ "$STASHED" == true ]]; then
    print_step "Restoring stashed working tree"
    git stash pop || print_warning "Could not restore stash automatically; run: git stash pop"
fi

print_step "Rollback for release $VERSION completed"
