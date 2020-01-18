#!/usr/bin/env bash
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-20020, Dockershelf Developers.
#
#   Please refer to AUTHORS.md for a complete list of Copyright holders.
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

# Exit early if there are errors and be verbose
set -euxo pipefail

# Some initial configuration
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_IMAGE_NAME="${1}"

# Load helper functions
source "${BASEDIR}/library.sh"

# Exit if we didn't get an image to test
if [ -z "${DOCKER_IMAGE_NAME}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

# Some initial configuration
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_NAME##*:}"
DOCKER_IMAGE_TARGET="${DOCKER_IMAGE_NAME##dockershelf/}"
DOCKER_IMAGE_TYPE="${DOCKER_IMAGE_TARGET%%:*}"

# Execute rspec for our test suite
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_TAG}" DOCKER_IMAGE_NAME="${DOCKER_IMAGE_NAME}" \
	DOCKER_IMAGE_TYPE="${DOCKER_IMAGE_TYPE}" rspec -c -f d "${BASEDIR}/${DOCKER_IMAGE_TYPE}/test-image.rb"