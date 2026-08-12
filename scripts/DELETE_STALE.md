# Docker Hub untagged image cleanup

Manual operator script (`scripts/delete-stale.sh`) for listing and deleting **untagged manifests** on Docker Hub. It is not wired into CI. Weekly cleanup of leftover **named** tags (`*-test`, `*-amd64`, `*-arm64`) is `.github/workflows/clean-master.yml`.

There is still no official Hub “prune untagged” API. Listing untagged manifests uses Hub’s undocumented Image Management endpoint (session cookie). Deleting a known digest uses the official OCI Registry API.

## Commands

| Command | What it does |
| --- | --- |
| `list-untagged` | After a **full** Hub crawl, print up to `MAX_UNTAGGED_LIMIT` untagged digests |
| `delete-untagged` | After a **full** Hub crawl, delete **every** untagged digest found (the list limit is ignored) |

Run from the **repo root**:

```bash
bash scripts/delete-stale.sh list-untagged
bash scripts/delete-stale.sh delete-untagged
```

## Why untagged manifests exist

Typical sources:

1. Pushing a new image with the same tag (the previous digest becomes untagged)
2. Deleting a tag while the manifest remains
3. Multi-arch builds leaving intermediate manifests
4. Temporary build/test tags that were later retagged or removed

Untagged manifests still count against Hub storage. They do not show as named tags; they appear in Hub’s Image Management UI and via this script.

## Prerequisites

- `jq`
- Docker Hub username + password **or** [personal access token](https://hub.docker.com/settings/security) with Read, Write, and Delete
- A logged-in Hub **session cookie** (required to list untagged manifests)

## Setup

### 1. Session cookie

1. Log into Docker Hub in a browser
2. Open Developer Tools (F12) → Network → refresh
3. Click any request to `hub.docker.com`
4. Copy the entire `Cookie:` request header value

Cookies expire. If listing starts failing with access errors, copy a fresh cookie.

### 2. `.env` at the repo root

The script always `source`s `.env` from the **repository root** (the directory above `scripts/`). That file **overwrites** the same variables if you exported them on the command line.

```bash
DH_USERNAME=your-docker-username
DH_PASSWORD=your-docker-password-or-token
DOCKER_HUB_COOKIE="sessionid=abc123;csrftoken=def456;..."
REPO="dockershelf/python"
MAX_UNTAGGED_LIMIT=100
MAX_PAGINATION_REQUESTS=150
```

Quote `DOCKER_HUB_COOKIE`. Prefer a personal access token as `DH_PASSWORD`.

**`REPO`:** space-separated Hub repos. The script walks them in order. To operate on one repo, put only that name in `.env` — a leading `REPO=...` on the shell command is replaced when `.env` defines `REPO`.

## What the limits actually do

| Variable | Default | Effect |
| --- | --- | --- |
| `MAX_UNTAGGED_LIMIT` | `100` | **Display cap for `list-untagged` only.** Applied **after** tagged-digest fetch + full manifest pagination. Does **not** stop Hub pagination. Ignored by `delete-untagged`. |
| `MAX_PAGINATION_REQUESTS` | `150` | Hard stop on Image Management pages (`Request N:` in the log). Each page returns up to **15** digests. Pagination continues until Hub sends no `lastEvaluatedKey`, or this cap is hit. |

Order of work for **each** repo:

1. Fetch the digest of **every tagged image** (Registry API)
2. Paginate **all** manifests (`Request 1:`, `Request 2:`, …) until Hub is done or `MAX_PAGINATION_REQUESTS`
3. Diff: manifests whose digest is not in the tagged set
4. `list-untagged`: print the first `MAX_UNTAGGED_LIMIT` of those  
   `delete-untagged`: delete **all** of those (no preview, no list cap)

A small `MAX_UNTAGGED_LIMIT` (for example `5`) does **not** make listing stop after five Hub pages. To bound crawl cost, lower `MAX_PAGINATION_REQUESTS` (incomplete inventory) or wait out the full pagination.

## Usage

```bash
# Uses REPO and limits from .env
bash scripts/delete-stale.sh list-untagged

# Delete every untagged digest found for REPO in .env
bash scripts/delete-stale.sh delete-untagged
```

`delete-untagged` does not show a capped preview first. It crawls, then deletes every untagged digest it found.

## Rate limiting

The script watches Hub `x-ratelimit-remaining` headers, waits when remaining ≤ 5, prints a countdown, and continues after reset. Hub is typically about 180 requests per hour. Large repos plus a high `MAX_PAGINATION_REQUESTS` will spend most of the time in that wait loop.

## Troubleshooting

**Cookie:** expired, truncated, or missing `sessionid` / `csrftoken` → copy a fresh full `Cookie:` header.

**Auth:** wrong username/token, or a PAT without Delete.

**Wrong repository:** `.env` `REPO` overwrote the value you passed on the command line.

**Listing stopped at `Request N` with a small `MAX_UNTAGGED_LIMIT`:** expected. Pagination is gated by `MAX_PAGINATION_REQUESTS`, not the list cap.

**Long waits:** rate limit, not a hang. Lower `MAX_PAGINATION_REQUESTS` only if a partial crawl is acceptable.

## Warnings

- Deleted manifests cannot be recovered.
- Untagged is not the same as unused; some digests may still be referenced.
- Test on a non-production repository first.
- Cookie and Hub password/token belong in `.env` (gitignored). Do not commit them.
