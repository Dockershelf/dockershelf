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

# Exit early if there are errors and be verbose
set -ex

# Some initial configuration
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SECMIRROR="http://security.debian.org"
MIRROR="http://httpredir.debian.org/debian"

# Packages to install at the end
DPKG_DEPENDS="iproute inetutils-ping locales curl ca-certificates"

# Load helper functions
source "${BASEDIR}/library.sh"

# Remove tianon's config
rm -rfv "/etc/apt/apt.conf.d/docker-clean" \
        "/etc/apt/apt.conf.d/docker-gzip-indexes" \
        "/etc/apt/apt.conf.d/docker-autoremove-suggests" \
        "/etc/apt/apt.conf.d/docker-no-languages" \
        "/etc/dpkg/dpkg.cfg.d/docker-apt-speedup"

# Configuring DNS
{
    echo "nameserver 8.8.8.8"
    echo "nameserver 8.8.4.4"
} | tee "/etc/resolv.conf" > /dev/null

# Configure this locale please
echo "en_US.UTF-8 UTF-8" > "/etc/locale.gen"

# Configure apt sources
echo "deb ${MIRROR} ${DEBIAN_RELEASE} main" > "/etc/apt/sources.list"

if [ "${DEBIAN_RELEASE}" != "sid" ]; then
    {
        echo "deb ${MIRROR} ${DEBIAN_RELEASE}-updates main"
        echo "deb ${SECMIRROR} ${DEBIAN_RELEASE}/updates main"
    } | tee -a "/etc/apt/sources.list" > /dev/null
fi

# Dpkg, please always install configurations from upstream and be fast.
{
    echo "force-confmiss"
    echo "force-confdef"
    echo "force-confnew"
    echo "force-overwrite"
    echo "force-unsafe-io"
} | tee "/etc/dpkg/dpkg.cfg.d/100-dpkg" > /dev/null

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
    echo 'Apt::Update::Post-Invoke { "/usr/share/dockershelf/debian/clean-apt.sh"; };'
    echo 'Dpkg::Post-Invoke { "/usr/share/dockershelf/debian/clean-dpkg.sh"; };'
} | tee "/etc/apt/apt.conf.d/100-apt" > /dev/null

# Install dependencies and upgrade
cmdretry apt-get update
cmdretry apt-get upgrade
cmdretry apt-get install ${DPKG_DEPENDS}

# Configure locales
update-locale LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"

# Final cleaning
find "/usr" -name "*.py[co]" -print0 | xargs -0r rm -rfv
find "/usr" -name "__pycache__" -type d -print0 | xargs -0r rm -rfv
rm -rfv "/tmp/"* "/usr/share/doc/"* "/usr/share/locale/"* \
        "/usr/share/man/"* "/var/cache/debconf/"* \
        "/var/cache/apt/"* "/var/tmp/"* "/var/log/"* \
        "/var/lib/apt/lists/"*