#!/bin/bash

set -e

# Default version type is patch
VERSION_TYPE=${1:-patch}
APP_NAME=${2:-Release}

# Non-interactive mode flag
NON_INTERACTIVE=${NON_INTERACTIVE:-false}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${GREEN}[RELEASE]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate version type
if [[ ! "$VERSION_TYPE" =~ ^(major|minor|patch)$ ]]; then
    print_error "Invalid version type: $VERSION_TYPE"
    print_error "Valid options are: major, minor, patch"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Check if git working directory is clean
if ! git diff-index --quiet HEAD --; then
    print_error "Working directory is not clean"
    exit 1
fi

# Check if git flow is initialized
if ! git config --get gitflow.branch.master >/dev/null 2>&1; then
    print_warning "Git flow not initialized. Initializing with default settings..."
    git flow init -d
fi

# Get current version for release name
CURRENT_VERSION=$(grep "current_version" setup.cfg | cut -d' ' -f3)

# Check if $CURRENT_VERSION is not a version
if ! echo "$CURRENT_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    print_error "Current version is not a valid version"
    exit 1
fi

print_step "Current version: $CURRENT_VERSION"

# Calculate new version using bumpversion in dry-run mode
NEW_VERSION=$(bumpversion --dry-run --list $VERSION_TYPE | grep "new_version=" | cut -d'=' -f2)

# Check if $NEW_VERSION is not a version
if ! echo "$NEW_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    print_error "New version is not a valid version"
    exit 1
fi

print_step "New version will be: $NEW_VERSION"

# Confirm with user (unless in non-interactive mode)
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

# Make sure we are in the develop branch
print_step "Checking out develop branch"
git checkout develop

# Make sure we have the latest changes
print_step "Pulling latest changes"
git pull origin develop

# Start git flow release
print_step "Starting git flow release: $NEW_VERSION"
git flow release start $NEW_VERSION

# Bump version
print_step "Bumping version to $NEW_VERSION"
bumpversion --no-commit $VERSION_TYPE

# Update changelog
print_step "Updating changelog"
if command -v gitchangelog >/dev/null 2>&1; then
    gitchangelog >HISTORY.md
else
    print_warning "gitchangelog not found, skipping changelog update"
fi

# Commit changes
print_step "Committing version bump and changelog"
git add .
git commit -S -m "Updating Changelog and version to $NEW_VERSION"

# Delete the tag made by bumpversion (we'll let git flow create the final tag)
print_step "Removing temporary tag"
git tag -d $NEW_VERSION 2>/dev/null || true

# Configure git for non-interactive mode
print_step "Configuring git for non-interactive mode"
git config --local core.editor ":"        # Use ":" as editor (no-op command)
git config --local merge.ours.driver true # Handle merge conflicts automatically

# Set environment variables for non-interactive mode
export GIT_MERGE_AUTOEDIT=no
export GPG_TTY=$(tty) 2>/dev/null || true # For GPG signing

# Finish git flow release
print_step "Finishing git flow release"
git flow release finish -s -p -m "Release version $NEW_VERSION" $NEW_VERSION

# Clean up git configuration
git config --local --unset core.editor 2>/dev/null || true
git config --local --unset merge.ours.driver 2>/dev/null || true

# Create GitHub release
print_step "Creating GitHub release"
if command -v gh >/dev/null 2>&1; then
    # Check if user is authenticated with GitHub CLI
    if gh auth status >/dev/null 2>&1; then
        # Generate release notes from changelog
        RELEASE_NOTES=""

        # Read descriptive text from markdown file
        DESCRIPTION_TEXT=""
        if [ -f "RELEASE_DESCRIPTION.md" ]; then
            DESCRIPTION_TEXT=$(cat RELEASE_DESCRIPTION.md)
        fi

        if [ -f "HISTORY.md" ]; then
            # Extract the latest version's changelog entry
            RELEASE_CONTENT=$(awk "/^## $NEW_VERSION \(/ { flag=1; next } flag && /^## [0-9]+\.[0-9]+\.[0-9]+ \(/ { exit } flag" HISTORY.md)
            RELEASE_NOTES="$DESCRIPTION_TEXT

## What's new in $NEW_VERSION
$RELEASE_CONTENT

Read [HISTORY](HISTORY.md) for more info.

**Full Changelog**: https://github.com/$(gh repo view --json owner,name -q '.owner.login + "/" + .name')/compare/$CURRENT_VERSION...$NEW_VERSION"
        fi

        # Create the release
        print_step "Creating GitHub release $NEW_VERSION"
        if gh release create "$NEW_VERSION" \
            --title "$APP_NAME $NEW_VERSION" \
            --notes "$RELEASE_NOTES" \
            --latest; then
            print_step "GitHub release created successfully!"
        else
            print_warning "Failed to create GitHub release. You can create it manually later."
        fi
    else
        print_warning "GitHub CLI not authenticated. Please run 'gh auth login' first."
        print_warning "You can create the GitHub release manually later."
    fi
else
    print_warning "GitHub CLI (gh) not found. Install it with: brew install gh"
    print_warning "You can create the GitHub release manually later."
fi

print_step "Release $NEW_VERSION completed successfully!"
print_step "Next steps:"
echo "  1. Close the milestone in GitHub (if applicable)"
echo "  2. Write about the new version in your blog"
echo "  3. Share the release on social media"
