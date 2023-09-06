#!/usr/bin/env bash
#
# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2023, Dockershelf Developers.

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
set -euxo pipefail

# Some initial configuration
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load helper functions
source "${BASEDIR}/library.sh"

DOCKER_IMAGE_NAME="${1}"
BRANCH="${2}"

if [ "${BRANCH}" == "develop" ]; then
    DOCKER_IMAGE_NAME_SUFFIX="-dev"
else
    DOCKER_IMAGE_NAME_SUFFIX=""
fi

# Exit if we didn't get an image to test
if [ -z "${DOCKER_IMAGE_NAME}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

DOCKER_IMAGE_TAG="${DOCKER_IMAGE_NAME##*:}"
DOCKER_IMAGE_TARGET="${DOCKER_IMAGE_NAME##dockershelf/}"
DOCKER_IMAGE_TYPE="${DOCKER_IMAGE_TARGET%%:*}"
DOCKER_IMAGE_TYPE_VERSION="${DOCKER_IMAGE_TAG%%-*}"
DOCKER_TEST_IMAGE_NAME="${DOCKER_IMAGE_NAME}-test${DOCKER_IMAGE_NAME_SUFFIX}"

# Execute rspec for our test suite (amd64)
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_TAG}" \
    DOCKER_IMAGE_NAME="${DOCKER_TEST_IMAGE_NAME}-amd64" \
    DOCKER_IMAGE_TYPE="${DOCKER_IMAGE_TYPE}" \
    DOCKER_IMAGE_TYPE_VERSION="${DOCKER_IMAGE_TYPE_VERSION}" \
    DOCKER_IMAGE_ARCH="amd64" \
    rspec \
    --color \
    --backtrace \
    --format documentation \
    "${BASEDIR}/${DOCKER_IMAGE_TYPE}/test-image.rb"

# Execute rspec for our test suite (arm64)
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_TAG}" \
    DOCKER_IMAGE_NAME="${DOCKER_TEST_IMAGE_NAME}-arm64" \
    DOCKER_IMAGE_TYPE="${DOCKER_IMAGE_TYPE}" \
    DOCKER_IMAGE_TYPE_VERSION="${DOCKER_IMAGE_TYPE_VERSION}" \
    DOCKER_IMAGE_ARCH="arm64" \
    rspec \
    --color \
    --backtrace \
    --format documentation \
    "${BASEDIR}/${DOCKER_IMAGE_TYPE}/test-image.rb"
