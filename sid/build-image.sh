#!/usr/bin/env bash

set -e

SUITE="sid"
ARCH="amd64"
VARIANT="minbase"
INCLUDE="iproute iputils-ping locales"
MIRROR="http://cdn.debian.net/debian"
TARGET="/tmp/docker-rootfs-debootstrap-${SUITE}-$$-${RANDOM}"

# bootstrap
mkdir -p "${TARGET}"
debootstrap --verbose --variant="${VARIANT}" --no-check-gpg \
    --arch="${ARCH}" "${SUITE}" "${TARGET}" "${MIRROR}"

cp clean-image.sh ${TARGET}/usr/share/internal/sid/
cd "${TARGET}"

# prevent init scripts from running during install/update
{
    echo $'#!/bin/sh\nexit 101'
} | tee usr/sbin/policy-rc.d > /dev/null

chmod +x usr/sbin/policy-rc.d
chroot . dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true sbin/initctl

# Dpkg, please always install configurations from upstream, be fast
# and no questions asked.
{
    echo 'force-confmiss'
    echo 'force-confnew'
    echo 'force-overwrite'
    echo 'force-unsafe-io'
} | tee etc/dpkg/dpkg.cfg.d/100-dpkg > /dev/null

# Apt, don't give me translations, assume always a positive answer,
# don't fill my image with recommended stuff i didn't told you to install,
# be permissive with packages without visa.
{
    echo 'Acquire::Languages "none";'
    echo 'Apt::Get::Assume-Yes "true";'
    echo 'Apt::Install-Recommends "false";'
    echo 'Apt::Get::AllowUnauthenticated "true";'
    echo 'Dpkg::Post-Invoke { "/usr/share/internal/sid/clean-image.sh"; }; '
} | tee etc/apt/apt.conf.d/100-apt > /dev/null

chroot . apt-get install ${INCLUDE}
chroot . apt-get clean
chroot . apt-get autoremove

