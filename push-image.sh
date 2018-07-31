#!/usr/bin/env bash
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-2018, Dockershelf Developers.
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
set -euo pipefail

# Load helper functions
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${BASEDIR}/library.sh"

# Exit if we didn't get an image to build
if [ -z "${1}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

# Exit if we didn't get an image to build
if [ -z "${2}" ] || [ -z "${3}" ]; then
    msgerror "Username or Password for Docker Hub were not given. Aborting."
    exit 1
fi

# Some initial configuration
DOCKER_IMAGE_NAME="${1}"
DH_USERNAME="${2}"
DH_PASSWORD="${3}"

# Login & push
cmdretry docker login --username ${DH_USERNAME} --password ${DH_PASSWORD}
cmdretry docker push ${DOCKER_IMAGE_NAME}