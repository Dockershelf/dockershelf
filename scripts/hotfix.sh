#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${GREEN}[HOTFIX]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Check if git flow is initialized
if ! git config --get gitflow.branch.master >/dev/null 2>&1; then
    print_warning "Git flow not initialized. Initializing with default settings..."
    git flow init -d
fi

# Get current version for hotfix name
CURRENT_VERSION=$(grep "current_version" .bumpversion.cfg | cut -d' ' -f3)
print_step "Current version: $CURRENT_VERSION"

# Calculate new version using bumpversion in dry-run mode
# Hotfixes always increment patch version
NEW_VERSION=$(bumpversion --dry-run --list patch | grep new_version | cut -d'=' -f2)
print_step "New hotfix version will be: $NEW_VERSION"

# Confirm with user
read -p "Proceed with hotfix $NEW_VERSION? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Hotfix cancelled"
    exit 1
fi

# Start git flow hotfix
print_step "Starting git flow hotfix: $NEW_VERSION"
git flow hotfix start $NEW_VERSION

# Bump version
print_step "Bumping version to $NEW_VERSION"
bumpversion --no-commit --new-version $NEW_VERSION patch

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

# Finish git flow hotfix
print_step "Finishing git flow hotfix"
git flow hotfix finish -s -p $NEW_VERSION

# Create GitHub release
print_step "Creating GitHub release"
if command -v gh >/dev/null 2>&1; then
    # Check if user is authenticated with GitHub CLI
    if gh auth status >/dev/null 2>&1; then
        # Generate release notes from changelog
        RELEASE_NOTES=""
        if [ -f "HISTORY.md" ]; then
            # Extract the latest version's changelog entry
            RELEASE_CONTENT=$(awk "/^$NEW_VERSION \(/ { flag=1; next } /^[0-9]+\.[0-9]+\.[0-9]+ \(/ && flag { flag=0 } flag" HISTORY.md | head -n -1)
            RELEASE_NOTES="## Hotfix $NEW_VERSION
$RELEASE_CONTENT

This is a hotfix release addressing critical issues.

Read [HISTORY](HISTORY.md) for more info.

**Full Changelog**: https://github.com/$(gh repo view --json owner,name -q '.owner.login + "/" + .name')/compare/$CURRENT_VERSION...$NEW_VERSION"
        fi

        # Fallback to simple release notes if changelog parsing fails
        if [ -z "$RELEASE_NOTES" ]; then
            # Get commit messages between current and new version
            COMMIT_MESSAGES=""
            if git tag | grep -q "^$CURRENT_VERSION$"; then
                # Get commits from the current version tag to HEAD
                COMMIT_MESSAGES=$(git log --pretty=format:"- %s" $CURRENT_VERSION..HEAD)
            else
                # Fallback: get recent commits if no tag exists for current version
                COMMIT_MESSAGES=$(git log --pretty=format:"- %s" -10)
            fi

            RELEASE_NOTES="## Hotfix $NEW_VERSION
$COMMIT_MESSAGES

This is a hotfix release addressing critical issues.

Read [HISTORY](HISTORY.md) for more info.

**Full Changelog**: https://github.com/$(gh repo view --json owner,name -q '.owner.login + "/" + .name')/compare/$CURRENT_VERSION...$NEW_VERSION"
        fi

        # Create the release
        print_step "Creating GitHub release $NEW_VERSION"
        if gh release create "$NEW_VERSION" \
            --title "Hotfix $NEW_VERSION" \
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

print_step "Hotfix $NEW_VERSION completed successfully!"
print_step "Next steps:"
echo "  1. Close the milestone in GitHub (if applicable)"
echo "  2. Write about the hotfix in your blog (if necessary)"
echo "  3. Notify users about the critical fix"
