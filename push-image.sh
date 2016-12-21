#!/usr/bin/env bash

set -euo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_IMAGE_NAME="${1}"

source "${BASEDIR}/library.sh"

if [ -z "${DOCKER_IMAGE_NAME}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

DOCKER_IMAGE_TARGET="$( echo ${DOCKER_IMAGE_NAME%%:*} | awk -F'/' '{print toupper($2)}' )"
MB_CURRENT_API_END="$( eval 'echo ${MB_'"${DOCKER_IMAGE_TARGET}"'_API_END}' )"

cmdretry curl -H 'Content-Type: application/json' --data '{update: true}' -X POST ${MB_CURRENT_API_END}
cmdretry docker login --username ${DH_USERNAME} --password ${DH_PASSWORD} >/dev/null 2>&1
cmdretry docker push ${DOCKER_IMAGE_NAME}