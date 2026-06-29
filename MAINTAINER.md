# Maintainer Guide

Quick reminders for Dockershelf.

## Feature work

1. Plan and implement on a feature branch (`feature/*` → `develop`).
2. Run QA, lint/build, open or update a PR to `develop`.

Repeat until ready to ship.

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
- **Auto-merge** — `pr-auto-merge.yml` after that workflow is green; head
  `feature/**` or `dependabot/**` only.

## Before `make release-*`

- Tools: `git`, git-flow, Docker (running), `make`, `gh`, bumpversion, GPG (`user.signingkey`).
- Clean working tree (release stops if format mutates files).

## One-time GitHub setup

- `develop` — PR + checks from `pr.yml`.
- `master` — restrict pushes.
- `release/*` — `push.yml` lists `release/**` and ends with **Release Gate** (manual patch).
- Tags — restrict creation to maintainers.
