#!/usr/bin/env bash
#
# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2022, Dockershelf Developers.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Exit early if there are errors and be verbose
set -exuo pipefail

# Some initial configuration
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load helper functions
source "${BASEDIR}/library.sh"

# eg. dockershelf/debian:sid
DOCKER_IMAGE_NAME="${1}"
# eg. unstable
DEBIAN_SUITE="${2}"
DH_USERNAME="${3}"
DH_PASSWORD="${4}"
BRANCH="${5}"

if [ "${BRANCH}" == "develop" ]; then
    DOCKER_IMAGE_NAME_SUFFIX="-dev"
fi

# Exit if we didn't get an image to build
if [ -z "${DOCKER_IMAGE_NAME}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

# eg. sid
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_NAME##*:}"
# eg. debian:stable
DOCKER_IMAGE_TARGET="${DOCKER_IMAGE_NAME##dockershelf/}"
# eg. /home/user/dockershelf/debian/sid
DOCKER_IMAGE_DIR="${BASEDIR}/${DOCKER_IMAGE_TARGET/://}"
# eg. debian
DOCKER_IMAGE_TYPE="${DOCKER_IMAGE_TARGET%%:*}"
# eg. /home/user/dockershelf/debian
DOCKER_IMAGE_TYPE_DIR="${BASEDIR}/${DOCKER_IMAGE_TYPE}"
# eg. dockershelf/debian:sid-test
DOCKER_TEST_IMAGE_NAME="${DOCKER_IMAGE_NAME}-test${DOCKER_IMAGE_NAME_SUFFIX}"

# Current date
BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Current commit
VCS_REF="$(git rev-parse --short HEAD)"

# Let's get the tag that matches the current commit
# Or get me the commit, which means we are building an unstable image
if git describe --tags ${VCS_REF} >/dev/null 2>&1; then
    VERSION="$(git describe --tags ${VCS_REF})"
else
    VERSION="${VCS_REF}"
fi

# Test if the selected image has a configuration directory here
if [ ! -d "${DOCKER_IMAGE_DIR}" ]; then
    msgerror "\"${DOCKER_IMAGE_NAME}\" image is not available. Aborting."
    exit 1
fi

# Copy library.sh because we need some helper functions
if [ -f "${BASEDIR}/library.sh" ]; then
    cp "${BASEDIR}/library.sh" "${DOCKER_IMAGE_DIR}"
fi

# Copy the building script
if [ -f "${DOCKER_IMAGE_TYPE_DIR}/build-image.sh" ]; then
    cp "${DOCKER_IMAGE_TYPE_DIR}/build-image.sh" "${DOCKER_IMAGE_DIR}"
fi

# Copy latex sample if we are building Latex
if [ "${DOCKER_IMAGE_TYPE}" == "latex" ]; then
    cp "${DOCKER_IMAGE_TYPE_DIR}/sample.tex" "${DOCKER_IMAGE_DIR}"
fi

if [ "${DOCKER_IMAGE_TYPE}" != "debian" ] && [ "${BRANCH}" == "develop" ]; then
    sed -i -r 's|FROM\s*(.*?)|FROM \1-dev|g' "${DOCKER_IMAGE_DIR}/Dockerfile"
fi

# workaround to exporting the multi-arch image from buildkit to docker
# we push the image to dockerhub with a -test suffix and then we
# pull it into docker and rename it
docker login --username ${DH_USERNAME} --password ${DH_PASSWORD}

# Build the docker image
cd "${DOCKER_IMAGE_DIR}" &&
    docker buildx build --push \
        --platform linux/arm64,linux/amd64 \
        --build-arg BUILD_DATE="${BUILD_DATE}" \
        --build-arg VCS_REF="${VCS_REF}" \
        --build-arg VERSION="${VERSION}" \
        -t ${DOCKER_TEST_IMAGE_NAME} .

docker pull --platform linux/arm64 ${DOCKER_TEST_IMAGE_NAME}
docker tag ${DOCKER_TEST_IMAGE_NAME} ${DOCKER_TEST_IMAGE_NAME}-arm64

docker pull --platform linux/amd64 ${DOCKER_TEST_IMAGE_NAME}
docker tag ${DOCKER_TEST_IMAGE_NAME} ${DOCKER_TEST_IMAGE_NAME}-amd64

# Remove unnecessary files
rm -rfv "${DOCKER_IMAGE_DIR}"/*.sh "${DOCKER_IMAGE_DIR}"/*.js \
    "${DOCKER_IMAGE_DIR}"/*.tex "${DOCKER_IMAGE_DIR}"/*.conf \
    "${DOCKER_IMAGE_DIR}/base"
