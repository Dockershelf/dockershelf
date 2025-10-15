## Maintainer Notes

If you are reading this, you probably forgot how to release a new version. Keep
reading.

### Making a new release

1. Create a new milestone in GitHub. Plan the features of your new release. Assign
existing bugs to your new milestone.
2. Start a new feature:

        git flow feature start <feature name>

3. Code, code and code. More coding. Mess it up several times. Push to feature
branch. Watch Travis go red. Write unit tests. Watch Travis go red again. Don't
leave uncommitted changes.
4. Finish your feature:

        git flow feature finish <feature name>

5. Repeat 2-4 for every other feature you have planned for this release.
6. When you're done with the features and ready to publish, ensure your working
directory is clean and you're on the develop branch.
7. Run the release script:

        make release-<major|minor|patch> [App Name]

   For example:
   - `make release-patch` - for a patch release (bug fixes)
   - `make release-minor` - for a minor release (new features)
   - `make release-major` - for a major release (breaking changes)

   This script will automatically:
   - Initialize git flow if needed
   - Start the git flow release
   - Bump the version number
   - Update the changelog (HISTORY.md)
   - Commit the changes
   - Finish the git flow release with signed tags
   - Push to GitHub
   - Create a GitHub release (if GitHub CLI is installed and authenticated)

8. Close the milestone in GitHub.
9. Write about your new version in your blog. Tweet it, post it on facebook.

### Making a new hotfix

1. Create a new milestone in GitHub. Assign existing bugs to your new milestone.
2. If you need to make code changes for the hotfix:

        git flow hotfix start <version>
        # Make your code changes here
        git add .
        git commit -S -m "Fix: description of your fix"

3. Run the hotfix script (it will start the hotfix if not already started):

        make hotfix [App Name]

   The script will prompt you to confirm the new hotfix version before proceeding.

   This script will automatically:
   - Initialize git flow if needed
   - Start the git flow hotfix with the new patch version
   - Bump the patch version number
   - Update the changelog (HISTORY.md)
   - Commit the version changes
   - Finish the git flow hotfix with signed tags
   - Push to GitHub
   - Create a GitHub release with "(Hotfix)" suffix (if GitHub CLI is installed and authenticated)

   **Note**: If you've already started the hotfix manually (step 2), the script will fail at
   the `git flow hotfix start` step. In this case, you'll need to finish manually or modify
   the script to skip the start step.

4. Close the milestone in GitHub.
5. Write about your hotfix in your blog (if necessary). Notify users about the critical fix.
