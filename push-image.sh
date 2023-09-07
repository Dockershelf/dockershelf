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
set -exuo pipefail

# Some initial configuration
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Load helper functions
source "${BASEDIR}/library.sh"

DOCKER_IMAGE_NAME="${1}"
DH_USERNAME="${2}"
DH_PASSWORD="${3}"
DOCKER_IMAGE_EXTRA_TAGS="${4}"
BRANCH="${5}"

if [ "${BRANCH}" == "develop" ]; then
    DOCKER_IMAGE_NAME_SUFFIX="-dev"
else
    DOCKER_IMAGE_NAME_SUFFIX=""
fi

# Exit if we didn't get an image to push
if [ -z "${DOCKER_IMAGE_NAME}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

# Exit if we didn't get credentials
if [ -z "${DH_USERNAME}" ] || [ -z "${DH_PASSWORD}" ]; then
    msgerror "Username or Password for Docker Hub were not given. Aborting."
    exit 1
fi

DOCKER_TEST_IMAGE_NAME="${DOCKER_IMAGE_NAME}-test${DOCKER_IMAGE_NAME_SUFFIX}"
DOCKER_FINAL_IMAGE_NAME="${DOCKER_IMAGE_NAME}${DOCKER_IMAGE_NAME_SUFFIX}"

# Login
docker login --username ${DH_USERNAME} --password ${DH_PASSWORD}

docker tag ${DOCKER_TEST_IMAGE_NAME}-arm64 ${DOCKER_FINAL_IMAGE_NAME}-arm64
docker push ${DOCKER_FINAL_IMAGE_NAME}-arm64

docker tag ${DOCKER_TEST_IMAGE_NAME}-amd64 ${DOCKER_FINAL_IMAGE_NAME}-amd64
docker push ${DOCKER_FINAL_IMAGE_NAME}-amd64

docker manifest rm ${DOCKER_FINAL_IMAGE_NAME} || true
docker manifest create ${DOCKER_FINAL_IMAGE_NAME} \
    --amend ${DOCKER_FINAL_IMAGE_NAME}-arm64 \
    --amend ${DOCKER_FINAL_IMAGE_NAME}-amd64
docker manifest inspect ${DOCKER_FINAL_IMAGE_NAME}
docker manifest push --purge ${DOCKER_FINAL_IMAGE_NAME}

if [ -n "${DOCKER_IMAGE_EXTRA_TAGS}" ]; then
    for EXTRA_TAG in ${DOCKER_IMAGE_EXTRA_TAGS}; do

        DOCKER_EXTRA_TAG_IMAGE_NAME="${EXTRA_TAG}${DOCKER_IMAGE_NAME_SUFFIX}"

        # Login
        docker login --username ${DH_USERNAME} --password ${DH_PASSWORD}

        docker tag ${DOCKER_TEST_IMAGE_NAME}-arm64 ${DOCKER_EXTRA_TAG_IMAGE_NAME}-arm64
        docker push ${DOCKER_EXTRA_TAG_IMAGE_NAME}-arm64

        docker tag ${DOCKER_TEST_IMAGE_NAME}-amd64 ${DOCKER_EXTRA_TAG_IMAGE_NAME}-amd64
        docker push ${DOCKER_EXTRA_TAG_IMAGE_NAME}-amd64

        docker manifest rm ${DOCKER_EXTRA_TAG_IMAGE_NAME} || true
        docker manifest create ${DOCKER_EXTRA_TAG_IMAGE_NAME} \
            --amend ${DOCKER_EXTRA_TAG_IMAGE_NAME}-arm64 \
            --amend ${DOCKER_EXTRA_TAG_IMAGE_NAME}-amd64
        docker manifest inspect ${DOCKER_EXTRA_TAG_IMAGE_NAME}
        docker manifest push --purge ${DOCKER_EXTRA_TAG_IMAGE_NAME}


    done
fi
