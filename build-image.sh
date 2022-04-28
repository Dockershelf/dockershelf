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

# Load helper functions
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${BASEDIR}/library.sh"

# Exit if we didn't get an image to build
if [ -z "${1}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

# Some initial configuration
DOCKER_IMAGE_NAME="${1}"
DEBIAN_SUITE="${2}"
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_NAME##*:}"
DOCKER_IMAGE_TARGET="${DOCKER_IMAGE_NAME##dockershelf/}"
DOCKER_IMAGE_DIR="${BASEDIR}/${DOCKER_IMAGE_TARGET/://}"
DOCKER_IMAGE_TYPE="${DOCKER_IMAGE_TARGET%%:*}"
DOCKER_IMAGE_TYPE_DIR="${BASEDIR}/${DOCKER_IMAGE_TYPE}"
BUILD_DATE="$( date -u +"%Y-%m-%dT%H:%M:%SZ" )"

# Current commit
VCS_REF="$( git rev-parse --short HEAD )"

# Let's get the tag that matches the current commit
# Or get me the commit, which means we are building an unstable image
if git describe --tags ${VCS_REF} >/dev/null 2>&1; then
    VERSION="$( git describe --tags ${VCS_REF} )"
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

# Create a base filesystem if we are building a debian image
if [ "${DOCKER_IMAGE_TYPE}" == "debian" ]; then
    cd "${DOCKER_IMAGE_DIR}" && \
        sudo docker run \
            -v "${DOCKER_IMAGE_DIR}:/tmp/dockershelf" \
            -w "/tmp/dockershelf" \
            debian:stable \
            bash -c "apt-get update && \
                apt-get install -y debootstrap && \
                bash build-image.sh ${DOCKER_IMAGE_TAG} ${DEBIAN_SUITE}"
fi

# Copy latex sample if we are building Latex
if [ "${DOCKER_IMAGE_TYPE}" == "latex" ]; then
    cp "${DOCKER_IMAGE_TYPE_DIR}/sample.tex" "${DOCKER_IMAGE_DIR}"
fi

# Copy Node build script and Odoo config if we are building Odoo
if [ "${DOCKER_IMAGE_TYPE}" == "odoo" ]; then
    cp "${DOCKER_IMAGE_TYPE_DIR}/odoo.conf" "${DOCKER_IMAGE_DIR}"
    cp "${DOCKER_IMAGE_TYPE_DIR}/docker-entrypoint.sh" "${DOCKER_IMAGE_DIR}"
    cp "${DOCKER_IMAGE_TYPE_DIR}/wait-for-psql.py" "${DOCKER_IMAGE_DIR}"
fi

# Build the docker image
cd "${DOCKER_IMAGE_DIR}" && \
    sudo docker build --build-arg BUILD_DATE="${BUILD_DATE}" \
        --build-arg VCS_REF="${VCS_REF}" --build-arg VERSION="${VERSION}" \
        -t ${DOCKER_IMAGE_NAME} .

# Remove unnecessary files
sudo rm -rfv "${DOCKER_IMAGE_DIR}"/*.sh "${DOCKER_IMAGE_DIR}"/*.js \
    "${DOCKER_IMAGE_DIR}"/*.tex "${DOCKER_IMAGE_DIR}"/*.conf \
    "${DOCKER_IMAGE_DIR}/base"