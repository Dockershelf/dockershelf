#!/usr/bin/env bash
#
# Build All Dockershelf Images Script
# 
# This script builds and tests all supported Dockershelf images locally.
# It automatically discovers supported image combinations and handles
# the build/test process with proper error handling and progress tracking.

# Exit early if there are errors and be verbose
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Some initial configuration
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${BASEDIR}/.env"
LOG_DIR="${BASEDIR}/build-logs"
FAILED_BUILDS=()
SUCCESSFUL_BUILDS=()
TOTAL_IMAGES=0
CURRENT_IMAGE=0

# Default values
DEFAULT_BRANCH="develop"
BRANCH="${1:-$DEFAULT_BRANCH}"
SKIP_TESTS="${2:-false}"

# Load helper functions
source "${BASEDIR}/library.sh"

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to create .env file template if it doesn't exist
create_env_template() {
    if [ ! -f "${ENV_FILE}" ]; then
        print_color $YELLOW "Creating .env file template..."
        cat > "${ENV_FILE}" << 'EOF'
# Docker Hub Credentials
# Replace with your actual credentials
DH_USERNAME=your_dockerhub_username
DH_PASSWORD=your_dockerhub_password

# Optional: Git branch to build (default: develop)
# BRANCH=develop

# Optional: Skip tests (default: false)
# SKIP_TESTS=false
EOF
        print_color $RED "❌ Please edit .env file with your Docker Hub credentials!"
        print_color $BLUE "📝 Edit: ${ENV_FILE}"
        exit 1
    fi
}

# Function to load environment variables
load_env() {
    if [ -f "${ENV_FILE}" ]; then
        # Export variables from .env file
        set -a
        source "${ENV_FILE}"
        set +a
    else
        print_color $RED "❌ .env file not found!"
        exit 1
    fi
    
    # Validate required variables
    if [ -z "${DH_USERNAME:-}" ] || [ -z "${DH_PASSWORD:-}" ]; then
        print_color $RED "❌ Docker Hub credentials not properly set in .env file!"
        print_color $BLUE "📝 Please edit: ${ENV_FILE}"
        exit 1
    fi
    
    if [ "${DH_USERNAME}" = "your_dockerhub_username" ]; then
        print_color $RED "❌ Please replace placeholder credentials in .env file!"
        exit 1
    fi
}

# Function to setup logging
setup_logging() {
    mkdir -p "${LOG_DIR}"
    print_color $BLUE "📝 Logs will be saved to: ${LOG_DIR}"
}

# Function to discover all supported images
discover_images() {
    local images=()
    
    print_color $BLUE "🔍 Discovering supported images..."
    
    # Debian base images
    for debian_dir in "${BASEDIR}/debian"/*/; do
        if [ -d "${debian_dir}" ] && [ -f "${debian_dir}/Dockerfile" ]; then
            local debian_version=$(basename "${debian_dir}")
            images+=("dockershelf/debian:${debian_version}")
        fi
    done
    
    # Python images
    for python_dir in "${BASEDIR}/python"/*/; do
        if [ -d "${python_dir}" ] && [ -f "${python_dir}/Dockerfile" ]; then
            local python_version=$(basename "${python_dir}")
            images+=("dockershelf/python:${python_version}")
        fi
    done
    
    # Node images
    for node_dir in "${BASEDIR}/node"/*/; do
        if [ -d "${node_dir}" ] && [ -f "${node_dir}/Dockerfile" ]; then
            local node_version=$(basename "${node_dir}")
            images+=("dockershelf/node:${node_version}")
        fi
    done
    
    # Go images
    for go_dir in "${BASEDIR}/go"/*/; do
        if [ -d "${go_dir}" ] && [ -f "${go_dir}/Dockerfile" ]; then
            local go_version=$(basename "${go_dir}")
            images+=("dockershelf/go:${go_version}")
        fi
    done
    
    # LaTeX images
    for latex_dir in "${BASEDIR}/latex"/*/; do
        if [ -d "${latex_dir}" ] && [ -f "${latex_dir}/Dockerfile" ]; then
            local latex_version=$(basename "${latex_dir}")
            images+=("dockershelf/latex:${latex_version}")
        fi
    done
    
    echo "${images[@]}"
}

# Function to get debian suite for an image
get_debian_suite() {
    local image_name=$1
    local image_tag="${image_name##*:}"
    
    case "${image_tag}" in
        *sid*)
            echo "unstable"
            ;;
        *bookworm*)
            echo "stable"
            ;;
        *bullseye*)
            echo "oldstable"
            ;;
        *trixie*)
            echo "testing"
            ;;
        sid)
            echo "unstable"
            ;;
        bookworm)
            echo "stable"
            ;;
        bullseye)
            echo "oldstable"
            ;;
        trixie)
            echo "testing"
            ;;
        basic|full)
            # LaTeX images are based on bookworm
            echo "stable"
            ;;
        *)
            # Default to stable for other cases
            echo "stable"
            ;;
    esac
}

# Function to build a single image
build_image() {
    local image_name=$1
    local debian_suite=$(get_debian_suite "${image_name}")
    local log_file="${LOG_DIR}/build-$(echo ${image_name} | tr '/:' '_').log"
    
    CURRENT_IMAGE=$((CURRENT_IMAGE + 1))
    
    print_color $BLUE "🔨 Building [${CURRENT_IMAGE}/${TOTAL_IMAGES}]: ${image_name}"
    print_color $BLUE "   Debian suite: ${debian_suite}"
    print_color $BLUE "   Branch: ${BRANCH}"
    print_color $BLUE "   Log: ${log_file}"
    
    # Run the build with logging
    if bash "${BASEDIR}/build-image.sh" \
        "${image_name}" \
        "${debian_suite}" \
        "${DH_USERNAME}" \
        "${DH_PASSWORD}" \
        "${BRANCH}" \
        > "${log_file}" 2>&1; then
        
        print_color $GREEN "✅ Successfully built: ${image_name}"
        SUCCESSFUL_BUILDS+=("${image_name}")
    else
        print_color $RED "❌ Failed to build: ${image_name}"
        print_color $RED "   Check log: ${log_file}"
        FAILED_BUILDS+=("${image_name}")
    fi
}

# Function to test a single image
test_image() {
    local image_name=$1
    local log_file="${LOG_DIR}/test-$(echo ${image_name} | tr '/:' '_').log"
    
    print_color $BLUE "🧪 Testing: ${image_name}"
    print_color $BLUE "   Log: ${log_file}"
    
    # Run the test with logging
    if bash "${BASEDIR}/test-image.sh" "${image_name}" "${BRANCH}" > "${log_file}" 2>&1; then
        print_color $GREEN "✅ Successfully tested: ${image_name}"
    else
        print_color $RED "❌ Failed to test: ${image_name}"
        print_color $RED "   Check log: ${log_file}"
    fi
}

# Function to print summary
print_summary() {
    print_color $BLUE "\n📊 BUILD SUMMARY"
    print_color $BLUE "===================="
    print_color $GREEN "✅ Successful builds: ${#SUCCESSFUL_BUILDS[@]}"
    print_color $RED "❌ Failed builds: ${#FAILED_BUILDS[@]}"
    print_color $BLUE "📊 Total images: ${TOTAL_IMAGES}"
    
    if [ ${#SUCCESSFUL_BUILDS[@]} -gt 0 ]; then
        print_color $GREEN "\n✅ Successfully built images:"
        for image in "${SUCCESSFUL_BUILDS[@]}"; do
            print_color $GREEN "   - ${image}"
        done
    fi
    
    if [ ${#FAILED_BUILDS[@]} -gt 0 ]; then
        print_color $RED "\n❌ Failed to build images:"
        for image in "${FAILED_BUILDS[@]}"; do
            print_color $RED "   - ${image}"
        done
        print_color $RED "\n🔍 Check individual log files in: ${LOG_DIR}"
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [BRANCH] [SKIP_TESTS]"
    echo ""
    echo "Parameters:"
    echo "  BRANCH      Git branch to build (default: develop)"
    echo "  SKIP_TESTS  Skip testing phase (default: false)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Build develop branch with tests"
    echo "  $0 main               # Build main branch with tests"
    echo "  $0 develop true       # Build develop branch, skip tests"
    echo ""
    echo "Configuration:"
    echo "  Edit .env file to set Docker Hub credentials"
    echo ""
}

# Function to check prerequisites
check_prerequisites() {
    print_color $BLUE "🔍 Checking prerequisites..."
    
    # Check if docker is installed and running
    if ! command -v docker &> /dev/null; then
        print_color $RED "❌ Docker is not installed!"
        exit 1
    fi
    
    # Check if docker buildx is available
    if ! docker buildx version &> /dev/null; then
        print_color $RED "❌ Docker buildx is not available!"
        exit 1
    fi
    
    # Check if we're in the right directory
    if [ ! -f "${BASEDIR}/build-image.sh" ]; then
        print_color $RED "❌ build-image.sh not found. Are you in the dockershelf directory?"
        exit 1
    fi
    
    # Check if bundle (ruby) is available for tests
    if [ "${SKIP_TESTS}" != "true" ] && ! command -v bundle &> /dev/null; then
        print_color $YELLOW "⚠️  Bundle (Ruby) not found. Tests will be skipped."
        SKIP_TESTS="true"
    fi
    
    print_color $GREEN "✅ Prerequisites check passed!"
}

# Main execution
main() {
    print_color $BLUE "🚀 Dockershelf Build All Images Script"
    print_color $BLUE "======================================="
    
    # Show usage if help requested
    if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
        show_usage
        exit 0
    fi
    
    # Check prerequisites
    check_prerequisites
    
    # Create .env template if needed
    create_env_template
    
    # Load environment variables
    load_env
    
    # Setup logging
    setup_logging
    
    # Discover all supported images
    local all_images=($(discover_images))
    TOTAL_IMAGES=${#all_images[@]}
    
    if [ ${TOTAL_IMAGES} -eq 0 ]; then
        print_color $RED "❌ No supported images found!"
        exit 1
    fi
    
    print_color $GREEN "✅ Found ${TOTAL_IMAGES} supported images"
    print_color $BLUE "📋 Branch: ${BRANCH}"
    print_color $BLUE "🧪 Skip tests: ${SKIP_TESTS}"
    print_color $BLUE ""
    
    # List all images to be built
    print_color $BLUE "📋 Images to build:"
    for image in "${all_images[@]}"; do
        print_color $BLUE "   - ${image}"
    done
    print_color $BLUE ""
    
    # Ask for confirmation
    read -p "Do you want to proceed with building all images? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_color $YELLOW "⏹️  Build cancelled by user"
        exit 0
    fi
    
    # Build phase
    print_color $BLUE "\n🔨 STARTING BUILD PHASE"
    print_color $BLUE "========================"
    
    local start_time=$(date +%s)
    
    # Build all images
    for image in "${all_images[@]}"; do
        build_image "${image}"
        sleep 2  # Brief pause between builds
    done
    
    local build_end_time=$(date +%s)
    local build_duration=$((build_end_time - start_time))
    
    print_color $GREEN "✅ Build phase completed in ${build_duration} seconds"
    
    # Test phase (only if not skipped and we have successful builds)
    if [ "${SKIP_TESTS}" != "true" ] && [ ${#SUCCESSFUL_BUILDS[@]} -gt 0 ]; then
        print_color $BLUE "\n🧪 STARTING TEST PHASE"
        print_color $BLUE "======================="
        
        # Test only successfully built images
        for image in "${SUCCESSFUL_BUILDS[@]}"; do
            test_image "${image}"
            sleep 1  # Brief pause between tests
        done
        
        local test_end_time=$(date +%s)
        local test_duration=$((test_end_time - build_end_time))
        print_color $GREEN "✅ Test phase completed in ${test_duration} seconds"
    else
        print_color $YELLOW "⏭️  Test phase skipped"
    fi
    
    local total_end_time=$(date +%s)
    local total_duration=$((total_end_time - start_time))
    
    # Print final summary
    print_summary
    print_color $BLUE "\n⏱️  Total execution time: ${total_duration} seconds"
    
    # Exit with error code if any builds failed
    if [ ${#FAILED_BUILDS[@]} -gt 0 ]; then
        exit 1
    else
        print_color $GREEN "\n🎉 All builds completed successfully!"
        exit 0
    fi
}

# Run main function with all arguments
main "$@" 