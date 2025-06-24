# Build All Dockershelf Images Script

This script automates the process of building and testing all supported Dockershelf images locally. It discovers all available image combinations and handles the build/test process with proper error handling, progress tracking, and logging.

## Prerequisites

1. **Docker with buildx**: Make sure Docker is installed and running with buildx support
2. **Docker Hub Account**: You'll need Docker Hub credentials to push test images
3. **Ruby with bundler** (optional): Required only if you want to run tests
4. **Git**: The script uses git to determine commit information

## Setup

1. **Create credentials file**:
   ```bash
   cat > .env << 'EOF'
   # Docker Hub Credentials
   DH_USERNAME=your_actual_dockerhub_username
   DH_PASSWORD=your_actual_dockerhub_password

   # Optional settings
   # BRANCH=develop
   # SKIP_TESTS=false
   EOF
   ```

2. **Make the script executable** (if not already):
   ```bash
   chmod +x build-all-images.sh
   ```

## Usage

### Basic Usage
```bash
# Build all images on develop branch with tests
./build-all-images.sh

# Show help
./build-all-images.sh --help
```

### Advanced Usage
```bash
# Build specific branch
./build-all-images.sh main

# Build without tests
./build-all-images.sh develop true

# Build main branch without tests
./build-all-images.sh main true
```

## Supported Images

The script automatically discovers and builds all supported image combinations:

### Debian Base Images
- `dockershelf/debian:bookworm`
- `dockershelf/debian:bullseye`
- `dockershelf/debian:sid`
- `dockershelf/debian:trixie`

### Python Images
- `dockershelf/python:3.7-bookworm`
- `dockershelf/python:3.7-sid`
- `dockershelf/python:3.10-bookworm`
- `dockershelf/python:3.10-sid`
- `dockershelf/python:3.11-bookworm`
- `dockershelf/python:3.11-sid`
- `dockershelf/python:3.12-bookworm`
- `dockershelf/python:3.12-sid`
- `dockershelf/python:3.13-bookworm`
- `dockershelf/python:3.13-sid`

### Node.js Images
- `dockershelf/node:16-bookworm`
- `dockershelf/node:16-sid`
- `dockershelf/node:18-bookworm`
- `dockershelf/node:18-sid`
- `dockershelf/node:20-bookworm`
- `dockershelf/node:20-sid`
- `dockershelf/node:22-bookworm`
- `dockershelf/node:22-sid`
- `dockershelf/node:24-bookworm`
- `dockershelf/node:24-sid`

### Go Images
- `dockershelf/go:1.20-bookworm`
- `dockershelf/go:1.20-sid`
- `dockershelf/go:1.21-bookworm`
- `dockershelf/go:1.21-sid`
- `dockershelf/go:1.22-bookworm`
- `dockershelf/go:1.22-sid`
- `dockershelf/go:1.23-bookworm`
- `dockershelf/go:1.23-sid`
- `dockershelf/go:1.24-bookworm`
- `dockershelf/go:1.24-sid`

### LaTeX Images
- `dockershelf/latex:basic`
- `dockershelf/latex:full`

## Features

### 🔍 **Auto-Discovery**
- Automatically discovers all supported image combinations
- No need to manually maintain lists of images

### 📊 **Progress Tracking**
- Shows build progress with counters (e.g., "Building [5/32]")
- Colored output for easy status identification
- Real-time status updates

### 📝 **Comprehensive Logging**
- Individual log files for each build and test
- Logs saved to `build-logs/` directory
- Easy debugging when builds fail

### ✅ **Error Handling**
- Continues building other images if one fails
- Detailed summary of successful and failed builds
- Exit codes indicate overall success/failure

### 🧪 **Testing Integration**
- Automatic testing of successfully built images
- Uses existing Ruby test suite
- Option to skip tests for faster builds

### 🎯 **Smart Build Order**
- Builds base Debian images first (dependency order handled by Docker)
- Proper handling of different Debian suites (sid, bookworm, etc.)

## Example Output

```
🚀 Dockershelf Build All Images Script
=======================================
🔍 Checking prerequisites...
✅ Prerequisites check passed!
📝 Logs will be saved to: /path/to/dockershelf/build-logs
🔍 Discovering supported images...
✅ Found 32 supported images
📋 Branch: develop
🧪 Skip tests: false

📋 Images to build:
   - dockershelf/debian:bookworm
   - dockershelf/debian:sid
   [... more images ...]

Do you want to proceed with building all images? (y/N): y

🔨 STARTING BUILD PHASE
========================
🔨 Building [1/32]: dockershelf/debian:bookworm
   Debian suite: stable
   Branch: develop
   Log: /path/to/dockershelf/build-logs/build-dockershelf_debian_bookworm.log
✅ Successfully built: dockershelf/debian:bookworm

[... continues for all images ...]

📊 BUILD SUMMARY
====================
✅ Successful builds: 30
❌ Failed builds: 2
📊 Total images: 32

⏱️  Total execution time: 1800 seconds
🎉 All builds completed successfully!
```

## Log Files

Build and test logs are saved to `build-logs/` directory:
- `build-dockershelf_debian_bookworm.log` - Build log for debian:bookworm
- `test-dockershelf_python_3.11-sid.log` - Test log for python:3.11-sid
- etc.

## Troubleshooting

### Common Issues

1. **Docker not running**:
   ```
   ❌ Docker is not installed!
   ```
   Solution: Start Docker Desktop or Docker daemon

2. **Missing credentials**:
   ```
   ❌ Docker Hub credentials not properly set in .env file!
   ```
   Solution: Create `.env` file with your Docker Hub credentials

3. **Buildx not available**:
   ```
   ❌ Docker buildx is not available!
   ```
   Solution: Update Docker to a version that supports buildx

4. **Ruby/Bundle missing**:
   ```
   ⚠️  Bundle (Ruby) not found. Tests will be skipped.
   ```
   Solution: Install Ruby and bundler, or run with `SKIP_TESTS=true`

### Failed Builds

If builds fail, check the individual log files in `build-logs/` directory. Common issues:
- Network connectivity problems
- Docker Hub rate limiting
- Insufficient disk space
- Missing dependencies in base images

## Security Notes

- The `.env` file contains sensitive credentials and should never be committed to Git
- The script pushes test images to Docker Hub temporarily
- Test images are tagged with `-test` suffix for identification

## Integration with CI/CD

This script can be integrated into CI/CD pipelines:

```bash
# In your CI script
export DH_USERNAME=$DOCKER_HUB_USERNAME
export DH_PASSWORD=$DOCKER_HUB_PASSWORD
echo "DH_USERNAME=$DH_USERNAME" > .env
echo "DH_PASSWORD=$DH_PASSWORD" >> .env

./build-all-images.sh main true  # Build main branch, skip tests
``` 