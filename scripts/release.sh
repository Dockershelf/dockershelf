#!/usr/bin/env bash
set -euo pipefail

VERSION_TYPE=${1:-patch}
APP_NAME=${2:-Release}
NON_INTERACTIVE=${NON_INTERACTIVE:-false}
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_step() { echo -e "${GREEN}[RELEASE]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

source "$SCRIPT_DIR/lib.sh"

if [[ ! "$VERSION_TYPE" =~ ^(major|minor|patch)$ ]]; then
    print_error "Invalid version type: $VERSION_TYPE"
    print_error "Valid options are: major, minor, patch"
    exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

release_check_host_tools
release_require_clean_worktree

if ! git config --get gitflow.branch.master >/dev/null 2>&1; then
    print_warning "Git flow not initialized. Initializing with default settings..."
    git flow init -d
fi

CURRENT_VERSION=$(grep '^current_version = ' .bumpversion.cfg | awk '{print $3}')
if ! echo "$CURRENT_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    print_error "Current version is not a valid version"
    exit 1
fi

print_step "Current version: $CURRENT_VERSION"

NEW_VERSION=$(bumpversion --dry-run --list "$VERSION_TYPE" 2>/dev/null | grep '^new_version=' | cut -d'=' -f2-)

if ! echo "$NEW_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    print_error "New version is not a valid version"
    exit 1
fi

print_step "New version will be: $NEW_VERSION"

if [[ "$NON_INTERACTIVE" != "true" ]]; then
    read -p "Proceed with release $NEW_VERSION? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Release cancelled"
        exit 1
    fi
else
    print_step "Running in non-interactive mode, proceeding with release $NEW_VERSION"
fi

release_run_preflight

print_step "Checking out develop branch"
git checkout develop

print_step "Pulling latest changes"
git pull origin develop

print_step "Starting git flow release: $NEW_VERSION"
git flow release start "$NEW_VERSION"

print_step "Bumping version to $NEW_VERSION"
bumpversion --no-commit "$VERSION_TYPE"

release_run_post_bump_commands

print_step "Updating changelog"
if command -v gitchangelog >/dev/null 2>&1; then
    gitchangelog >HISTORY.md
else
    print_warning "gitchangelog not found, skipping changelog update"
fi

print_step "Committing version bump and changelog"
git add .
git commit -S -m "Updating Changelog and version to $NEW_VERSION"

print_step "Removing temporary tag"
git tag -d "$NEW_VERSION" 2>/dev/null || true

print_step "Publishing release branch to origin"
git push -u origin "release/$NEW_VERSION"

RELEASE_BRANCH_SHA=$(git rev-parse HEAD)
release_wait_for_branch_ci "release/$NEW_VERSION" "$RELEASE_BRANCH_SHA"

export PREVIOUS_VERSION="$CURRENT_VERSION"
release_finish_release "$NEW_VERSION" "$APP_NAME"

print_step "Release $NEW_VERSION completed successfully!"
