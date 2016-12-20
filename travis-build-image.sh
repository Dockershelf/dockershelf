#!/usr/bin/env bash

set -ex

BUILD_DATE="$( date -u +"%Y-%m-%dT%H:%M:%SZ" )"
VERSION="${TRAVIS_COMMIT}"

if git describe --tags ${TRAVIS_COMMIT} >/dev/null 2>&1; then
    VERSION="$( git describe --tags ${TRAVIS_COMMIT} )"
fi

if ls -1 "$( dirname "${DOCKER_IMAGE_DIR}" )"/*.sh >/dev/null 2>&1; then
    cp "$( dirname "${DOCKER_IMAGE_DIR}" )"/*.sh "${DOCKER_IMAGE_DIR}"
fi

cd "${DOCKER_IMAGE_DIR}" && \
    docker build --build-arg BUILD_DATE="${BUILD_DATE}" \
                 --build-arg VCS_REF="${TRAVIS_COMMIT}" \
                 --build-arg VERSION="${VERSION}" \
                 -t ${DOCKER_IMAGE_NAME} .