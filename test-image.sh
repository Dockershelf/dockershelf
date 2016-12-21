#!/usr/bin/env bash

set -euxo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_IMAGE_NAME="${1}"

source "${BASEDIR}/library.sh"

if [ -z "${DOCKER_IMAGE_NAME}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

DOCKER_IMAGE_TAG="${DOCKER_IMAGE_NAME##*:}"
DOCKER_IMAGE_TARGET="${DOCKER_IMAGE_NAME##luisalejandro/}"
DOCKER_IMAGE_DIR="${BASEDIR}/${DOCKER_IMAGE_TARGET/://}"
DOCKER_IMAGE_TYPE="${DOCKER_IMAGE_TARGET%%:*}"

# dockerfile_lint -f "${DOCKER_IMAGE_DIR}/Dockerfile"
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_TAG}" DOCKER_IMAGE_NAME="${DOCKER_IMAGE_NAME}" \
    DOCKER_IMAGE_TYPE="${DOCKER_IMAGE_TYPE}" rspec -c "${BASEDIR}/test-image.rb"