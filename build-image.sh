#!/usr/bin/env bash
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016, Dockershelf Developers.
#
#   Please refer to AUTHORS.rst for a complete list of Copyright holders.
#
#   Dockershelf is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Dockershelf is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see http://www.gnu.org/licenses.

set -ex

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_IMAGE_NAME="${1}"

source "${BASEDIR}/library.sh"

if [ -z "${DOCKER_IMAGE_NAME}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

DOCKER_IMAGE_DIR="${BASEDIR}/$( echo ${DOCKER_IMAGE_NAME##luisalejandro/} | sed 's|:|/|' )"
BUILD_DATE="$( date -u +"%Y-%m-%dT%H:%M:%SZ" )"
VCS_REF="$( git rev-parse --short HEAD )"
VERSION="${VCS_REF}"

if git describe --tags ${VCS_REF} >/dev/null 2>&1; then
    VERSION="$( git describe --tags ${VCS_REF} )"
fi

if [ -f "${BASEDIR}/library.sh" ]; then
    cp "${BASEDIR}/library.sh" "${DOCKER_IMAGE_DIR}"
fi

if ls -1 "$( dirname "${DOCKER_IMAGE_DIR}" )"/*.sh >/dev/null 2>&1; then
    cp "$( dirname "${DOCKER_IMAGE_DIR}" )"/*.sh "${DOCKER_IMAGE_DIR}"
fi

cd "${DOCKER_IMAGE_DIR}" && \
    docker build --build-arg BUILD_DATE="${BUILD_DATE}" \
                 --build-arg VCS_REF="${VCS_REF}" \
                 --build-arg VERSION="${VERSION}" \
                 -t ${DOCKER_IMAGE_NAME} .

rm "${DOCKER_IMAGE_DIR}"/*.sh