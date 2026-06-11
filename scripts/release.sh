#!/usr/bin/env bash
set -euo pipefail

VERSION_TYPE=${1:-patch}
APP_NAME=${2:-Release}
NON_INTERACTIVE=${NON_INTERACTIVE:-false}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_step() { echo -e "${GREEN}[RELEASE]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

if [[ ! "$VERSION_TYPE" =~ ^(major|minor|patch)$ ]]; then
    print_error "Invalid version type: $VERSION_TYPE"
    print_error "Valid options are: major, minor, patch"
    exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

if ! git diff-index --quiet HEAD --; then
    print_error "Working directory is not clean"
    exit 1
fi

if ! git config --get gitflow.branch.master >/dev/null 2>&1; then
    print_warning "Git flow not initialized. Initializing with default settings..."
    git flow init -d
fi

CURRENT_VERSION=$(grep "current_version" .bumpversion.cfg | cut -d' ' -f3)
if ! echo "$CURRENT_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    print_error "Current version is not a valid version"
    exit 1
fi

print_step "Current version: $CURRENT_VERSION"

NEW_VERSION=$(bumpversion --dry-run --list "$VERSION_TYPE" | grep "new_version=" | cut -d'=' -f2)
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

print_step "Checking out develop branch"
git checkout develop

print_step "Pulling latest changes"
git pull origin develop

print_step "Starting git flow release: $NEW_VERSION"
git flow release start "$NEW_VERSION"

print_step "Bumping version to $NEW_VERSION"
bumpversion --no-commit "$VERSION_TYPE"



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

print_step "Configuring git for non-interactive mode"
git config --local core.editor ":"
git config --local merge.ours.driver true
export GIT_MERGE_AUTOEDIT=no
export GPG_TTY=$(tty) 2>/dev/null || true

print_step "Finishing git flow release"
git flow release finish -s -p -m "Release version $NEW_VERSION" "$NEW_VERSION"

git config --local --unset core.editor 2>/dev/null || true
git config --local --unset merge.ours.driver 2>/dev/null || true

print_step "Verifying tag was pushed to remote"
MAX_RETRIES=5
RETRY_DELAY=3
TAG_EXISTS=false

for i in $(seq 1 "$MAX_RETRIES"); do
    if git ls-remote --tags origin | grep -q "refs/tags/$NEW_VERSION$"; then
        TAG_EXISTS=true
        print_step "Tag $NEW_VERSION found on remote"
        break
    fi
    if [ "$i" -lt "$MAX_RETRIES" ]; then
        print_warning "Tag not found on remote, retrying in ${RETRY_DELAY}s... (attempt $i/$MAX_RETRIES)"
        sleep "$RETRY_DELAY"
        git push origin master 2>/dev/null || true
        git push origin develop 2>/dev/null || true
        git push origin --tags 2>/dev/null || true
    fi
done

if [ "$TAG_EXISTS" = false ]; then
    print_error "Tag $NEW_VERSION was not found on remote after $MAX_RETRIES attempts"
    print_error "Please verify the push manually: git push origin --tags"
    exit 1
fi

if command -v gh >/dev/null 2>&1; then
    print_step "Creating GitHub release"
    gh release create "$NEW_VERSION" --title "$APP_NAME $NEW_VERSION" --generate-notes || true
else
    print_warning "GitHub CLI not found, skipping GitHub release creation"
fi

print_step "Release $NEW_VERSION completed successfully!"
