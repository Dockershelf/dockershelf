#!/usr/bin/env bash
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-2017, Dockershelf Developers.
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

# Exit early if there are errors and be verbose.
set -exuo pipefail

# Some default values.
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PY_SOURCE_TEMPDIR="$( mktemp -d )"
PY_VER_NUM_MINOR="$( echo ${PY_VER_NUM} | awk -F'.' '{print $1"."$2}')"
PY_VER_NUM_MAJOR="$( echo ${PY_VER_NUM} | awk -F'.' '{print $1}')"
PY_VER_NUM_MINOR_STR="python${PY_VER_NUM_MINOR}"
PY_VER_NUM_MAJOR_STR="python${PY_VER_NUM_MAJOR}"
MIRROR="http://deb.debian.org/debian"
SECMIRROR="http://deb.debian.org/debian-security"

# This is the list of python packages from debian that make up a minimal
# python installation. We will use them later.
if [ "${PY_DEBIAN_SUITE}" == "wheezy-security" ]; then
    PY_PKGS="${PY_VER_NUM_MINOR_STR}-minimal lib${PY_VER_NUM_MINOR_STR} \
        ${PY_VER_NUM_MINOR_STR} ${PY_VER_NUM_MINOR_STR}-dev"
else
    PY_PKGS="lib${PY_VER_NUM_MINOR_STR}-minimal \
        ${PY_VER_NUM_MINOR_STR}-minimal lib${PY_VER_NUM_MINOR_STR}-stdlib \
        lib${PY_VER_NUM_MINOR_STR} ${PY_VER_NUM_MINOR_STR} \
        lib${PY_VER_NUM_MINOR_STR}-dev ${PY_VER_NUM_MINOR_STR}-dev"
fi

# These are the folders of a debian python installation that we won't need.
PY_CLEAN_DIRS="/usr/share/lintian /usr/share/man /usr/share/pixmaps \
    /usr/share/doc /usr/share/applications"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude deborphan debian-keyring dpkg-dev"

# Load helper functions
source "${BASEDIR}/library.sh"

# Apt: Install tools
# ------------------------------------------------------------------------------
# We need to install the packages defined at ${DPKG_TOOLS_DEPENDS} because
# some commands are needed to download and process dependencies.

msginfo "Installing tools and upgrading image ..."
cmdretry apt-get update
cmdretry apt-get -d upgrade
cmdretry apt-get upgrade
cmdretry apt-get -d install ${DPKG_TOOLS_DEPENDS}
cmdretry apt-get install ${DPKG_TOOLS_DEPENDS}

# Python: Configure sources
# ------------------------------------------------------------------------------
# We will use Debian's repository to install the different versions of Python.

msginfo "Configuring /etc/apt/sources.list ..."
if [ "${PY_DEBIAN_SUITE}" == "wheezy-security" ]; then
    {
        echo "deb ${MIRROR} wheezy main"
        echo "deb ${SECMIRROR} wheezy/updates main"
    } | tee /etc/apt/sources.list.d/python.list > /dev/null
elif [ "${PY_DEBIAN_SUITE}" != "sid" ]; then
    {
        echo "deb ${MIRROR} ${PY_DEBIAN_SUITE} main"
    } | tee /etc/apt/sources.list.d/python.list > /dev/null
fi

cmdretry apt-get update

# Apt: Install runtime dependencies
# ------------------------------------------------------------------------------
# Now we use some shell/apt plumbing to get runtime dependencies.

msginfo "Installing python runtime dependencies ..."
DPKG_RUN_DEPENDS="$( aptitude search -F%p \
    $( printf '~RDepends:~n^%s$ ' ${PY_PKGS} ) | xargs | \
    sed "$( printf 's/\s%s\s/ /g;' ${PY_PKGS} )" )"
DPKG_DEPENDS="$( printf '%s\n' ${DPKG_RUN_DEPENDS} | \
    uniq | xargs )"

cmdretry apt-get -d install ${DPKG_DEPENDS}
cmdretry apt-get install ${DPKG_DEPENDS}

if [ "${PY_DEBIAN_SUITE}" == "jessie" ]; then
    cmdretry apt-get --allow-remove-essential purge findutils
    cmdretry apt-get -d -t jessie install findutils
    cmdretry apt-get -t jessie install findutils
fi

# Python: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${PY_PKGS}

msginfo "Installing Python ..."
cmdretry apt-get -d install ${PY_PKGS}
cmdretry apt-get install ${PY_PKGS}

if [ ! -f "/usr/bin/python" ]; then
    ln -s /usr/bin/${PY_VER_NUM_MINOR_STR} /usr/bin/python
fi

# Apt: Remove unnecessary packages
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages to shrink image size.

msginfo "Removing unnecessary packages ..."
# This is clever uh? I figured it out myself, ha!
cmdretry apt-get purge $( apt-mark showauto $( deborphan -a -n \
                                --no-show-section --guess-all --libdevel \
                                -p standard ) )
cmdretry apt-get autoremove

# This too
cmdretry apt-get purge $( aptitude search -F%p ~c ~g )
cmdretry apt-get autoremove

cmdretry apt-get purge ${DPKG_TOOLS_DEPENDS}
cmdretry apt-get autoremove

# Pip: Installation
# ------------------------------------------------------------------------------
# Let's bring in the old reliable pip guy.

msginfo "Installing pip ..."
if [ "${PY_VER_NUM}" == "3.2" ]; then
    ${PY_VER_NUM_MINOR_STR} -m easy_install setuptools==29.0.1
    curl -fsSL "https://bootstrap.pypa.io/3.2/get-pip.py" | \
        ${PY_VER_NUM_MINOR_STR} - 'setuptools==29.0.1'
elif [ "${PY_VER_NUM}" == "2.6" ]; then
    ${PY_VER_NUM_MINOR_STR} -m easy_install setuptools==29.0.1
    curl -fsSL "https://bootstrap.pypa.io/2.6/get-pip.py" | \
        ${PY_VER_NUM_MINOR_STR} - 'setuptools==29.0.1'
else
    ${PY_VER_NUM_MINOR_STR} -m easy_install setuptools
    curl -fsSL "https://bootstrap.pypa.io/get-pip.py" | \
        ${PY_VER_NUM_MINOR_STR}
fi

# Bash: Changing prompt
# ------------------------------------------------------------------------------
# To distinguish images.

cat >> "/etc/bash.bashrc" << 'EOF'

COLOR_YELLOW="\[\033[38;5;220m\]"
COLOR_BLUE="\[\033[38;5;33m\]"
COLOR_OFF="\[\033[0m\]"
PS1="\u@\h:${COLOR_YELLOW}Dockershelf/${COLOR_BLUE}Python${COLOR_OFF}:\w\$ "
EOF

# Final cleaning
# ------------------------------------------------------------------------------
# Buncha files we won't use.

msginfo "Removing unnecessary files ..."
find /usr -name "*.py[co]" -print0 | xargs -0r rm -rfv
find /usr -name "__pycache__" -type d -print0 | xargs -0r rm -rfv
rm -rfv "/tmp/"* "/usr/share/doc/"* "/usr/share/locale/"* "/usr/share/man/"* \
        "/var/cache/debconf/"* "/var/cache/apt/"* "/var/tmp/"* "/var/log/"* \
        "/var/lib/apt/lists/"*