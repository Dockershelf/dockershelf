# Maintainer Guide

Rosey maintainer workflow for Dockershelf. Each step is a skill invocation; details
live in the skill files under `.cursor/skills/`.

## Workflow overview

For each feature:

1. `rosey-lfg-code` — brainstorm requirements, create a plan, implement on a
   feature branch (via `rosey-brainstorm`, `rosey-plan`, `rosey-work`).
2. `rosey-lfg-quality` — QA review, lint/build after fixes, open or update PR
   (via `rosey-qa`, `rosey-pr`). PRs target `develop`. This skill does not merge
   PRs or fix CI; see **Pull request CI and auto-merge** below.

Repeat 1–2 for every feature in the release.

When `develop` is ready to ship:

3. `rosey-release` — publish a **release** (patch, minor, or major). Five gates:
   (1) Docker preflight (`make release-preflight`: `make lint`, `make format`,
   `make test`; on Python repos `make test` runs
   coverage),
   (2) `release/<version>` branch pushed,
   (3) **Push** workflow (`push.yml`) on the release branch — see **GitHub branch
   protection** for the one-time `push.yml` patch,
   (4) tag and GitHub release (`scripts/release.sh` / git-flow finish),
   (5) **Publish Release** workflow (`release.yml`) after publish (lint/tests on the release tag) —
   gate 5 is verified by `rosey-release` after `make release-*` completes, not by
   the release script. **Patch** releases attach a retroactive milestone from eligible
   closed issues since the prior release (see `rosey-release`). **Minor** and **major**
   require explicit confirmation of milestone handling before release scripts run.
   On failure, rolls back with `VERSION=<version> make undo-release` and halts.
   Optional post-bump hooks live in `.bumpversion.cfg` under `[rosey-maintainer]`.

## Pull request CI and auto-merge

- **`pr.yml`** — repo-specific CI on `pull_request` to `develop`. Each job's
  `name:` field becomes a candidate required status check on `develop`. Static sync
  injects a managed **Code Quality** Semgrep job block when the quality bundle is
  present; it may also strip legacy `push` backup triggers and `concurrency`. The
  dynamic phase may patch trigger/checkout security only (remove `pull_request_target`,
  PR-head checkout, and in-file approve/merge jobs).
- **`pr-auto-merge.yml`** — static-synced. Triggers on `workflow_run` after **Pull Request**
  completes successfully on an eligible **head** branch (`feature/**` or `dependabot/**`;
  not `release/**`). A gate job verifies the PR targets `develop` and head branch
  eligibility, then approve/merge via the GitHub API (no checkout of PR code). All jobs
  in **Pull Request** (including **Code Quality**) must be green before the workflow
  completes. Limited to `dependabot[bot]`, `cursor[bot]` (Cursor PR automation), and
  `github.repository_owner`. Integration PRs use `feature/<slug>` from git-flow
  (`rosey-work` / `rosey-pr`). Configure `REPO_PERSONAL_ACCESS_TOKEN` when Dependabot
  merges need permissions beyond `GITHUB_TOKEN`.
- **Cursor PR CI automation** — one Cursor automation per repo (fleet prompts in
  **rosey-maintainer-tools** `docs/cursor-automations/<repo>.md`; setup in
  `docs/cursor-pr-ci-automation.md`). Triggers on **failed PR checks** for
  owner/Dependabot PRs targeting `develop` on `feature/**` or `dependabot/**`
  (not on direct `develop` pushes). The agent pushes fixes to the **PR head
  branch** only; it does not approve or merge. When the **Pull Request** workflow
  succeeds (all jobs green, including **Code Quality** when present),
  `pr-auto-merge.yml` completes the merge. `rosey-lfg-quality` and `rosey-pr` do not
  fix CI or merge.

  Auto-merge eligibility:

  | Check | Rule |
  |-------|------|
  | Head branch | `feature/**` or `dependabot/**` |
  | Base branch | `develop` (gate) |
  | Actor | repo owner or Dependabot |
  | Required workflows | **Pull Request** workflow on same `head_sha` (includes **Code Quality** when bundle present) |
  | Excluded | `release/**`, PRs not targeting `develop`, external contributors |

## Skill reference

### `rosey-lfg-code`

Autonomous code stage: requirements → plan → implementation and lint/build.
Emits `ROSEY_LFG_QUALITY_HANDOFF` for the quality stage.

### `rosey-lfg-quality`

Autonomous quality stage: QA autofix, post-review lint, PR create/update.
Emits `<promise>DONE</promise>` when the PR is ready. Does not merge, watch, or
fix CI, create milestones, or publish releases.

### `rosey-release`

Release only: `patch` (default), `minor`, or `major`. Invoke from clean `develop`.
Arguments: `[mode:interactive|mode:non-interactive] [patch|minor|major]`. In
`mode:non-interactive`, runs `NON_INTERACTIVE=true make release-<type>` (e.g.
`make release-patch`). Gates 1–4 run inside `scripts/release.sh`; gate 5 is
verified by the skill after the Make target succeeds.

## Prerequisites (checked by release script)

- `git`, `git flow`, `docker` (daemon running), `make`, `gh` (authenticated),
  `bumpversion`, `gpg`
- `user.signingkey` configured with secret key available locally
- Clean working tree (no modified or untracked files)

## GitHub branch protection (configure once)

**`develop`** — require PR; required status checks must match job `name:` fields in
`.github/workflows/pr.yml` (including **Code Quality** when the managed block is
present). Run `rosey-maintain protect-github --apply` (after GitHub Pro on private
repos) to create the `Rosey: develop` ruleset with those checks (including
matrix-expanded job names where applicable).

**`master`** — restrict pushes; disallow force pushes.

**`release/*`** — `push.yml` must list `release/**` under `on.push.branches` and
include a terminal **Release Gate** job after all CI jobs (one-time manual patch;
static sync does not manage `push.yml`). `scripts/release.sh` waits for the full
**Push** workflow to succeed on the release branch before tagging.

**Version tags** — restrict creation to maintainers; prevent tag deletion except by
admins.
