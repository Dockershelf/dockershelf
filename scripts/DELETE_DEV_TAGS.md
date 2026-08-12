# Docker Hub `*-dev` tag cleanup

Manual operator script (`scripts/delete-dev-tags.sh`) for listing and deleting leftover **named** Hub tags that end in `-dev`, `-dev-amd64`, or `-dev-arm64`. It is not wired into CI.

Those tags were published by the old develop Hub pipeline (`trigger-develop` / `clean-develop`), which has been removed. Nothing in current CI publishes `*-dev` tags. PRs build locally via `make build` (`--no-push`).

This script deletes **tag names** via the official Hub v2 API. It does **not** prune untagged manifests. For that, use `scripts/delete-stale.sh` (see `DELETE_STALE.md`). Weekly cleanup of leftover **named** test tags (`*-test`, `*-amd64`, `*-arm64`) is `.github/workflows/clean-master.yml`.

## Commands

| Invocation | What it does |
| --- | --- |
| (default) | Dry-run: list matching tags; do not delete |
| `--apply` | Delete every matching tag found |

Run from the **repo root**:

```bash
./scripts/delete-dev-tags.sh
./scripts/delete-dev-tags.sh --apply
```

## Why these tags exist

The old develop pipeline pushed images with a `-dev` suffix (and per-arch extras such as `-dev-amd64` / `-dev-arm64`, plus `-test-dev` variants from the Buildx test round-trip). After that pipeline was dropped, those tags remained on Hub and still counted against storage.

A tag matches if it **ends** with:

- `-dev`
- `-dev-amd64`
- `-dev-arm64`

Examples that match: `3.12-sid-dev`, `bookworm-dev-amd64`, `20-sid-test-dev`.  
Examples that do **not** match: `3.12-sid`, `3.12-sid-test`, `3.12-sid-amd64`.

## Prerequisites

- `jq`
- Docker Hub username + password **or** [personal access token](https://hub.docker.com/settings/security) with Read, Write, and Delete

No session cookie. Unlike `delete-stale.sh`, this script logs in with `DH_USERNAME` / `DH_PASSWORD` and uses Hub’s public tags API.

## Setup

`.env` at the **repository root** (same file as `delete-stale.sh`):

```bash
DH_USERNAME=your-docker-username
DH_PASSWORD=your-docker-password-or-token
REPO="dockershelf/python dockershelf/node dockershelf/go dockershelf/debian dockershelf/latex"
```

Prefer a personal access token as `DH_PASSWORD`.

### Credentials vs `.env`

The script `source`s `.env`, then **restores** `DH_USERNAME` and `DH_PASSWORD` if they were already exported in the shell. Exported Hub credentials win over placeholder values in `.env`.

`REPO` is **not** restored that way. If `.env` defines `REPO`, it overwrites a `REPO=...` you put on the command line. To operate on one shelf, set `REPO` in `.env`, or omit `REPO` from `.env` and pass it on the command line.

Default `REPO` (when unset): the five Dockershelf shelves (`python`, `node`, `go`, `debian`, `latex`).

## Usage

```bash
# Dry-run all default shelves (or REPO from .env)
./scripts/delete-dev-tags.sh

# Delete matching tags
./scripts/delete-dev-tags.sh --apply
```

`--apply` lists matching tags per repo, then deletes them. There is no extra confirmation prompt.

## How it works

For each repository in `REPO`:

1. Log in to Hub (`POST /v2/users/login/`)
2. Paginate all tag names (`GET /v2/repositories/{repo}/tags?page_size=100`)
3. Keep names that match the `-dev` suffix rule above
4. Dry-run: print them  
   `--apply`: `DELETE /v2/repositories/{repo}/tags/{tag}/` for each

Deleting a tag can leave the underlying digest **untagged**. Reclaiming that storage is a separate `delete-stale.sh` pass.

## Troubleshooting

**Auth:** wrong username/token, or a PAT without Delete. Placeholder `.env` credentials are ignored if you already exported `DH_USERNAME` / `DH_PASSWORD`.

**Wrong repository:** `.env` `REPO` overwrote the value you passed on the command line.

**No matches:** expected if the one-off cleanup already ran, or if tags use a different suffix (`-test` without `-dev` is `clean-master.yml`, not this script).

**HTTP failure on delete:** the script continues, counts failures, and exits `1` if any delete failed.

## Warnings

- Deleted tags cannot be recovered.
- Always dry-run first.
- `--apply` has no confirmation prompt.
- Hub password/token belong in `.env` (gitignored). Do not commit them.
