# Docker Hub Untagged Image Cleanup Script

A simple, focused script for finding and deleting untagged Docker images from Docker Hub repositories.

## What It Does

**Two simple operations:**
- **`list-untagged`** - Shows untagged image manifests (digests)
- **`delete-untagged`** - Deletes all untagged image manifests

## Why Use This?

**Untagged images** are created when:
1. You push a new image with the same tag (old image becomes untagged)
2. You delete a tag but the manifest remains
3. Multi-architecture builds create intermediate manifests
4. Build processes create temporary manifests

These untagged images:
- ✅ Still consume storage space and count towards limits
- ✅ Are invisible in Docker Hub web interface 
- ✅ Can only be cleaned up via API (like this script)

## Prerequisites

1. **jq** - JSON processor
   ```bash
   # macOS
   brew install jq
   
   # Ubuntu/Debian  
   apt-get install jq
   ```

2. **Docker Hub account** - Username and password (or personal access token)

3. **Session cookie** - From your logged-in browser (required for finding untagged images)

## Setup

### 1. Get Session Cookie

**This is required** to access Docker Hub's internal API that lists untagged images:

1. **Log into Docker Hub** in your web browser
2. **Open Developer Tools** (F12)
3. **Go to Network tab** and refresh the page
4. **Click on any request** to `hub.docker.com`
5. **Find Request Headers** and copy the entire `Cookie:` value

Example: `Cookie: sessionid=abc123; csrftoken=def456; ...`

### 2. Configure Environment

Create a `.env` file in the parent directory:
```bash
DH_USERNAME=your-docker-username
DH_PASSWORD=your-docker-password-or-token
DOCKER_HUB_COOKIE="sessionid=abc123;csrftoken=def456;..."
REPO="dockershelf/python dockershelf/node dockershelf/go dockershelf/debian dockershelf/latex"
MAX_UNTAGGED_LIMIT=100
MAX_PAGINATION_REQUESTS=10
```

**Note:** The `DOCKER_HUB_COOKIE` value must be in quotes.

**Security Note:** While you can use your regular Docker Hub password, it's recommended to use a [personal access token](https://hub.docker.com/settings/security) instead for better security. Create one with Read, Write, Delete permissions and use it as the `DH_PASSWORD` value.

## Usage

### List Untagged Images
```bash
# List up to 100 untagged manifests (default limit)
REPO="dockershelf/python" ./delete-stale.sh list-untagged

# List up to 50 untagged manifests (set limit via environment)
REPO="dockershelf/python" MAX_UNTAGGED_LIMIT=50 ./delete-stale.sh list-untagged

# Use multiple repositories
REPO="dockershelf/python dockershelf/node" ./delete-stale.sh list-untagged
```

### Delete Untagged Images
```bash
# Delete all untagged manifests
REPO="dockershelf/python dockershelf/node" ./delete-stale.sh delete-untagged
```

**What happens:**
1. Shows preview of untagged manifests (up to limit)
2. Deletes **ALL** untagged manifests (not just preview)
3. Shows progress and final count

## Configuration

All configuration is done via environment variables:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `DH_USERNAME` | Docker Hub username | - | ✅ |
| `DH_PASSWORD` | Docker Hub password or personal access token | - | ✅ |
| `DOCKER_HUB_COOKIE` | Session cookie from browser | - | ✅ |
| `REPO` | Space-separated list of repositories | - | ✅ |
| `MAX_UNTAGGED_LIMIT` | Max manifests to show in preview | 100 | ❌ |
| `MAX_PAGINATION_REQUESTS` | Max pagination requests | 10 | ❌ |

## Rate Limiting

The script automatically handles Docker Hub's rate limits:

- **Monitors** rate limit headers (`x-ratelimit-remaining`)
- **Waits** when approaching limit (≤5 requests remaining)
- **Shows countdown** until rate limit resets
- **Continues** automatically after reset

Example output:
```
Request 175: Rate limit status - 5/180 remaining
[WARNING] Rate limit nearly exhausted (5/180 remaining)
[WARNING] Waiting for rate limit reset in 90 seconds...
Time remaining: 01:30
[INFO] Rate limit reset. Continuing...
```

## How It Works

1. **Gets tagged manifests** - Uses Docker Registry API to get digests for all tagged images
2. **Gets all manifests** - Uses Docker Hub's internal API to get all manifests (including untagged)
3. **Finds untagged** - Compares the two lists to identify untagged manifests
4. **Deletes by digest** - Uses Docker Registry API to delete untagged manifests

## Example Session

```bash
$ REPO="dockershelf/python" ./delete-stale.sh list-untagged
[INFO] Working with repository: dockershelf/python
[INFO] Getting tagged manifests...
[INFO] Getting all manifests...
Request 1: Initial GET request
Request 1: Rate limit status - 179/180 remaining
Request 1: Found 15 digest(s)
[INFO] Finding untagged manifests...
sha256:c4593a5a1aa4fe979b7c4b4f4c1fb279188875c6c939706cbb9b4cc5da9c6bc8
sha256:055b3dfe0a1653ed28037fe2a898726d06684749e2f48d2afe08a01eea14715c
sha256:7d016e05e7c564919f29e5f21e93c28d15c9eccd6aa53a8919755adfbb38d220

[INFO] Found 3 untagged manifest(s)

$ REPO="dockershelf/python" ./delete-stale.sh delete-untagged
[INFO] Getting complete list of untagged manifests for deletion...
[INFO] Deleting 3 untagged manifest(s) from dockershelf/python...
[INFO] Successfully deleted manifest: sha256:c4593a5a1aa4fe979b7c4b4f4c1fb279188875c6c939706cbb9b4cc5da9c6bc8
[INFO] Successfully deleted manifest: sha256:055b3dfe0a1653ed28037fe2a898726d06684749e2f48d2afe08a01eea14715c
[INFO] Successfully deleted manifest: sha256:7d016e05e7c564919f29e5f21e93c28d15c9eccd6aa53a8919755adfbb38d220
[INFO] Deletion complete for dockershelf/python. Deleted: 3, Failed: 0
```

## Troubleshooting

### Session Cookie Issues
- **Cookie expired**: Get a fresh cookie from browser
- **Access denied**: Ensure you have access to the repository
- **Invalid format**: Copy the entire `Cookie:` header value

### Authentication Errors  
- **Invalid credentials**: Check username and password/personal access token
- **Insufficient permissions**: If using a personal access token, ensure it has Read, Write, Delete permissions

### Rate Limit Issues
- **Too many requests**: Script automatically waits for reset
- **Long wait times**: Docker Hub limits are typically 180 requests per hour

## Important Notes

⚠️ **Always test first** on a non-production repository

⚠️ **Untagged ≠ Unused** - Some untagged images might still be referenced

⚠️ **No undo** - Deleted manifests cannot be recovered

⚠️ **Cookie expires** - You may need to refresh the session cookie periodically

⚠️ **Configuration via environment only** - All settings must be configured through environment variables or the `.env` file

---

**Need help?** Open an issue with your error message and (sanitized) command output. 