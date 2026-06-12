## Maintainer Notes

If you are reading this, you probably forgot how to release a new version. Keep
reading.

### Making a new release

1. Plan work from open issues. The release milestone is created later as
   retroactive documentation for the version that ships.
2. Start a feature branch from an up-to-date `develop`:

        git checkout develop
        git pull
        git flow feature start <feature name>

   (`git flow feature start` creates and checks out `feature/<feature name>` from
   `develop`. Equivalent: `git checkout -b feature/<feature name>`.)

3. Implement the feature on that branch. Commit often. Do not leave uncommitted
   changes when you push.

4. Push the branch and open a pull request against `develop`:

        git push -u origin feature/<feature name>
        gh pr create --base develop --head feature/<feature name> --title "..." --body "..."

   CI runs via `.github/workflows/pr.yml`. Fix failures on the feature branch;
   the PR updates automatically on push. Rosey skills stop at PR create/update;
   owner PRs are auto-approved and auto-merged by CI when configured.
   Consumers report `pr_opened`; task completion is recorded only after the
   linked GitHub issue closes on merge.

5. After the PR auto-merges into `develop`, sync locally:

        git checkout develop
        git pull
        git branch -d feature/<feature name>

6. Repeat steps 2-5 for every other feature you have planned for this release.
7. When you're done with the features and ready to publish, ensure your working
directory is clean and you're on the `develop` branch.
8. For the Rosey weekly release, the Linux CodeCandidates producer posts a
   `versionpromote` YAML message to `#rosey`. The macOS `versionpromote`
   consumer runs `rosey-release` and reports `versionpromote_result` to
   `#rosey-releases`.

   The release creates a retroactive milestone for the next patch version,
   assigns eligible parent issues (plus standalone issues with no parent/sub
   relationship) closed since the previous closed milestone, and runs the patch
   release script:

        make release-patch

   `APP_NAME` is set in each repository's `Makefile` and passed to the release
   script automatically for the GitHub release title. If there are no eligible
   parent or standalone issues for the week, do not create an empty milestone
   and do not publish a release. Sub-task issues close through PR merge
   (`Closes #N`) and are not assigned to release milestones directly.

   Manual maintainer releases may still use:
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

9. Close the milestone in GitHub on the same date as the release.
10. Write about your new version in your blog. Tweet it, post it on facebook.

### Making a new hotfix

1. Create a new milestone in GitHub. Assign existing bugs to your new milestone.
2. If you need to make code changes for the hotfix:

        git flow hotfix start <version>
        # Make your code changes here
        git add .
        git commit -S -m "Fix: description of your fix"

3. Run the hotfix script (it will start the hotfix if not already started):

        make hotfix

   `APP_NAME` is set in the repository's `Makefile` and passed to the hotfix
   script automatically for the GitHub release title.

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
