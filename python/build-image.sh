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
PY_VER_NUM_MINOR="$( echo ${PY_VER_NUM} | awk -F'.' '{print $1"."$2}')"
PY_VER_NUM_MAJOR="$( echo ${PY_VER_NUM} | awk -F'.' '{print $1}')"
PY_VER_NUM_MINOR_STR="python${PY_VER_NUM_MINOR}"
PY_VER_NUM_MAJOR_STR="python${PY_VER_NUM_MAJOR}"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude deborphan debian-keyring dpkg-dev"

# Load helper functions
source "${BASEDIR}/library.sh"

# Apt: Install tools
# ------------------------------------------------------------------------------
# We need to install the packages defined at ${DPKG_TOOLS_DEPENDS} because
# some commands are needed to download the source code before installing the
# build dependencies. Also, ${DPKG_BUILD_DEPENDS} must be installed to
# allow installation of Pythonz and Python.

msginfo "Installing tools, build depends and upgrading image ..."
cmdretry apt-get update
cmdretry apt-get -d upgrade
cmdretry apt-get upgrade
cmdretry apt-get -d install ${DPKG_TOOLS_DEPENDS}
cmdretry apt-get install ${DPKG_TOOLS_DEPENDS}

# Python: Installing
# ------------------------------------------------------------------------------
# We will use Pythonz to take care of python compilation for us.

msginfo "Configuring /etc/apt/sources.list ..."
cat > /etc/apt/sources.list.d/libssl.list << EOF
deb http://deb.debian.org/debian jessie-backports main
deb http://deb.debian.org/debian jessie main
EOF

{
    echo "deb [trusted=yes] http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu xenial main"
} | tee /etc/apt/sources.list.d/python.list > /dev/null

msginfo "Installing Python ..."
cmdretry apt-get update
cmdretry apt-get -d install ${PY_VER_NUM_MINOR_STR}
cmdretry apt-get install ${PY_VER_NUM_MINOR_STR}

rm -rfv /etc/apt/sources.list.d/libssl.list
cmdretry apt-get update

# Apt: Remove build depends
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages before installing python
# because some files might be confused with already installed python packages.

msginfo "Removing unnecessary packages ..."
# cmdretry apt-get purge $( echo ${DPKG_BUILD_DEPENDS} \
#     | sed "$( printf 's/\s%s\s/ /g;' ${DPKG_RUN_DEPENDS} )" )
# cmdretry apt-get autoremove

# This is clever uh? Figure it out myself, ha!
cmdretry apt-get purge $( apt-mark showauto $( deborphan -a -n \
                                --no-show-section --guess-all --libdevel \
                                -p standard ) )
cmdretry apt-get autoremove

# This too
cmdretry apt-get purge $( aptitude search -F%p ~c ~g )
cmdretry apt-get autoremove

cmdretry apt-get purge ${DPKG_TOOLS_DEPENDS}
cmdretry apt-get autoremove

# Linking to make this the default version of python
ln -sfv /usr/bin/${PY_VER_NUM_MAJOR_STR} /usr/bin/python

# Pip: Installation
# ------------------------------------------------------------------------------
# Let's bring in the old reliable pip guy.

msginfo "Installing pip ..."
if [ "${PY_VER_NUM}" == "3.2" ]; then
    curl -fsSL "https://bootstrap.pypa.io/3.2/get-pip.py" | ${PY_VER_NUM_MINOR_STR} - 'setuptools<30'
else
    curl -fsSL "https://bootstrap.pypa.io/get-pip.py" | ${PY_VER_NUM_MINOR_STR}
fi

# Changing bash prompt
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
rm -rfv /tmp/* /usr/share/doc/* /usr/share/locale/* /usr/share/man/* \
        /var/cache/debconf/* /var/cache/apt/* /var/tmp/* /var/log/* \
        /var/lib/apt/lists/*