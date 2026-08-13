# Maintainer Guide

Quick reminders for Dockershelf.

## Feature work

1. Plan and implement on a feature branch (`feature/*` → `develop`).
2. Run QA, lint/build, open or update a PR to `develop`.

Repeat until ready to ship.

## Commit messages

Subjects feed `HISTORY.md` via gitchangelog, then GitHub release notes on `make release-*`.

| Tag | Section | Use for |
| --- | ------- | ------- |
| `[ADD]` | Added | New user-facing capability |
| `[FIX]` | Fixed | Bug or broken behavior |
| `[REF]` | Changed | Behavior change that is not a new feature |
| `[DEL]` | Removed | Removal |

Format: `[TAG] Imperative user-facing summary.` Non-user-facing work (deps, lint, sync, CI): append `!cosmetic` / `!refactor` / `!wip`, or use a `CI:` prefix, so it is omitted from HISTORY. PR titles may stay Conventional-style; only commit subjects use these tags.

## Release

From **clean** `develop`:

| Step | Command |
|------|-----------------|
| Preflight | `make release-preflight` |
| Publish | `make release-patch` (or `release-minor` / `release-major`) |
| Rollback | `VERSION=<version> make undo-release` |

Preflight: `make image`, `make dependencies`, `make build`, `make format`, `make lint`, `make test` (`test` = coverage).
Release flow: `scripts/release.sh` (via Makefile `release-*` targets).
Post-bump hooks: `.bumpversion.cfg` → `[rosey-maintainer]`.

## PR CI (pointers)

- **Pull Request** — `.github/workflows/pr.yml` on PRs to `develop`.
- **Auto-merge** — `pr-auto-merge.yml` after that workflow succeeds; head
  `feature/**` or `dependabot/**` only. Actor allowlist: `dependabot[bot]`,
  `cursor[bot]`, `LuisAlejandro`, repository owner.

### Auto-merge behavior

- Binds mutations to `workflow_run.head_sha`. Stale events exit with a notice.
- Retries transient GitHub API errors (HTTP 429/5xx, network) on PR reads and
  `updateBranch` with exponential backoff before failing the mutate job.
- Behind base: arms native auto-merge, updates the branch with
  `REPO_PERSONAL_ACCESS_TOKEN` + `expected_head_sha`, then waits for fresh CI.
- Current head: native auto-merge + bot approval via `GITHUB_TOKEN`. If already
  approved and REST+GraphQL report clean, uses SHA-guarded REST merge fallback.
- Token boundary: PAT only on the `Update behind branch` step.

## Before `make release-*`

- Tools: `git`, git-flow, Docker (running), `make`, `gh`, bumpversion, GPG (`user.signingkey`).
- Clean working tree (release stops if format mutates files).

## Docker Hub publish

Public images rebuild **weekly** on Thursday via `schedule-master.yml` (06:00 UTC). That is the product offer.

- **Manual family rebuild:** `trigger-master.yml` (`workflow_dispatch`).
- **Tag cleanup:** `clean-master.yml` (first Thursday of the month, 08:00 UTC + manual).
- Recipe merges to `master` update git immediately; Hub waits until Thursday unless someone runs Trigger.
- There is no `*-dev` Hub pipeline. PRs already build locally via `make build` (`--no-push`).
- Leftover `*-dev` Hub tags: `./scripts/delete-dev-tags.sh` (dry-run) then `--apply`.
- `push.yml` is **release-gate only** (`release/**`). It does not publish Hub images.

`update.py` fills `%%MATRIX%%` in `trigger-master.yml.template`, `clean-master.yml.template`, and `schedule-master.yml.template`. Do not hand-edit the generated YAML and expect it to stay.

## One-time GitHub setup

- `develop` — PR + checks from `pr.yml`.
- `master` — restrict pushes. Hub publish is Thursday `schedule-master` or manual `trigger-master`, not a push matrix.
- `release/*` — `push.yml` lists `release/**` and ends with **Release Gate** (manual patch).
- Tags — restrict creation to maintainers.
