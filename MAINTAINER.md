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
  does not rewrite `pr.yml`; fleet sync may patch trigger/checkout security only
  (remove `pull_request_target`, PR-head checkout, and in-file approve/merge jobs).
- **`code-quality.yml`** — static-synced Semgrep OSS on `pull_request` to `develop`
  (job name **Code Quality**). Fails the PR check when Semgrep reports findings in
  the PR diff (`p/ci` + language ruleset, baseline scan). No SARIF upload to GitHub
  Security; gating is via the required **Code Quality** status check.
- **`pr-auto-merge.yml`** — static-synced. Triggers on `workflow_run` after **Pull Request**
  completes on an eligible **head** branch (`feature/**` or `dependabot/**`; not
  `release/**`). A gate job verifies the PR targets `develop`, required workflow runs
  succeeded for the PR `head_sha` (polling for **Code Quality** when the quality bundle
  is present), then approve/merge via the GitHub API (no checkout of PR code). Limited
  to `dependabot[bot]` and `github.repository_owner`. Integration PRs use
  `feature/<slug>` from git-flow (`rosey-work` / `rosey-pr`). Configure
  `REPO_PERSONAL_ACCESS_TOKEN` when owner merges need permissions beyond
  `GITHUB_TOKEN`. Post-PR CI failures are handled outside the LFG skills (e.g.
  Cursor Bugbot).

  Auto-merge eligibility:

  | Check | Rule |
  |-------|------|
  | Head branch | `feature/**` or `dependabot/**` |
  | Base branch | `develop` (gate) |
  | Actor | repo owner or Dependabot |
  | Required workflows | Pull Request (+ Code Quality when bundle present) on same `head_sha` |
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
`.github/workflows/pr.yml` **plus** **Code Quality** from static-synced
`code-quality.yml` when present. Run `rosey-maintain protect-github --apply` (after
GitHub Pro on private repos) to create the `Rosey: develop` ruleset with those
checks (including matrix-expanded job names where applicable).

**`master`** — restrict pushes; disallow force pushes.

**`release/*`** — `push.yml` must list `release/**` under `on.push.branches` and
include a terminal **Release Gate** job after all CI jobs (one-time manual patch;
static sync does not manage `push.yml`). `scripts/release.sh` waits for the full
**Push** workflow to succeed on the release branch before tagging.

**Version tags** — restrict creation to maintainers; prevent tag deletion except by
admins.
