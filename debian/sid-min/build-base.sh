#!/usr/bin/env bash

# Exit early if there are errors and be verbose
set -ex

# Set some enviroment variables
export TERM="xterm" DEBIAN_FRONTEND="noninteractive" \
       LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"

# Some initial configuration
SUITE="sid"
ARCH="amd64"
VARIANT="minbase"
MIRROR="http://deb.debian.org/debian"
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET="${BASEDIR}/base"

# Packages to install at the end
DPKG_DEPENDS="iproute2 iputils-ping locales curl ca-certificates"

# Let's use debootstrap to build our base
mkdir -pv ${TARGET}
debootstrap --verbose --no-check-gpg --no-check-certificate \
    --variant="${VARIANT}" --arch="${ARCH}" \
    "${SUITE}" "${TARGET}" "${MIRROR}"

# Prevent init scripts from running during install/update
echo $'#!/bin/sh\nexit 101' > "${TARGET}/usr/sbin/policy-rc.d"
chmod +x "${TARGET}/usr/sbin/policy-rc.d"

# Prevent invocation of init levels
chroot ${TARGET} dpkg-divert --local --rename --add /sbin/initctl
echo $'#!/bin/sh\nexit 0' > "${TARGET}/sbin/initctl"
chmod +x "${TARGET}/sbin/initctl"

# Configure this locale please
echo "en_US.UTF-8 UTF-8" > "${TARGET}/etc/locale.gen"

# Configure apt sources
echo "deb ${MIRROR} ${SUITE} main" > "${TARGET}/etc/apt/sources.list"

# Configure nameservers
{
    echo 'nameserver 8.8.8.8'
    echo 'nameserver 8.8.4.4'   
} | tee "${TARGET}/etc/resolv.conf" > /dev/null

# Dpkg, please always install configurations from upstream and be fast.
# Also, exclude all these paths from ever installing as I don't need them.
{
    echo "force-confmiss"
    echo "force-confdef"
    echo "force-confnew"
    echo "force-overwrite"
    echo "force-unsafe-io"
    echo "path-exclude /usr/share/doc/*"
    echo "path-exclude /usr/share/groff/*"
    echo "path-exclude /usr/share/info/*"
    echo "path-exclude /usr/share/linda/*"
    echo "path-exclude /usr/share/lintian/*"
    echo "path-exclude /usr/share/locale/*"
    echo "path-exclude /usr/share/man/*"
} | tee "${TARGET}/etc/dpkg/dpkg.cfg.d/100-dpkg" > /dev/null

# Apt, don't give me translations, assume always a positive answer,
# don't fill my image with recommended stuff I didn't told you to install,
# be permissive with packages without visa and clean your shit.
{
    echo 'Dir::Cache::pkgcache "";'
    echo 'Dir::Cache::srcpkgcache "";'
    echo 'Acquire::Languages "none";'
    echo 'Acquire::GzipIndexes "true";'
    echo 'Acquire::CompressionTypes::Order:: "gz";'
    echo 'Apt::Get::Assume-Yes "true";'
    echo 'Apt::Install-Suggests "false";'
    echo 'Apt::Install-Recommends "false";'
    echo 'Apt::Get::AllowUnauthenticated "true";'
    echo 'Apt::AutoRemove::SuggestsImportant "false";'
    echo 'Apt::Update::Post-Invoke { "/usr/share/docker/debian/sid-min/clean-apt.sh"; };'
    echo 'Dpkg::Post-Invoke { "/usr/share/docker/debian/sid-min/clean-dpkg.sh"; };'
} | tee "${TARGET}/etc/apt/apt.conf.d/100-apt" > /dev/null

# Copy our cleaning scripts
mkdir -pv "${TARGET}/usr/share/docker/debian/sid-min"
cp -pfv "${BASEDIR}/clean-apt.sh" "${BASEDIR}/clean-dpkg.sh" \
        "${TARGET}/usr/share/docker/debian/sid-min"

# Install dependencies and upgrade
chroot "${TARGET}" apt-get update
chroot "${TARGET}" apt-get install ${DPKG_DEPENDS}

# Configure locales
chroot "${TARGET}" update-locale LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"

# Final cleaning
find "${TARGET}/usr" -name "*.py[co]" -print0 | xargs -0r rm -rfv
find "${TARGET}/usr" -name "__pycache__" -type d -print0 | xargs -0r rm -rfv
rm -rfv "${TARGET}/tmp/"* "${TARGET}/usr/share/doc/"* "${TARGET}/usr/share/locale/"* \
        "${TARGET}/usr/share/man/"* "${TARGET}/var/cache/debconf/"* \
        "${TARGET}/var/cache/apt/"* "${TARGET}/var/tmp/"* "${TARGET}/var/log/"* \
        "${TARGET}/var/lib/apt/lists/"*

# Make our base tarball
tar -cJf "${BASEDIR}/base.tar.xz" -C "${TARGET}" .

# Remove build folder
rm -rf "${TARGET}"