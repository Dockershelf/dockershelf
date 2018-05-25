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
PY_PKGS="${PY_VER_NUM_MINOR_STR} ${PY_VER_NUM_MINOR_STR}-minimal \
	lib${PY_VER_NUM_MINOR_STR} lib${PY_VER_NUM_MINOR_STR}-stdlib \
	lib${PY_VER_NUM_MINOR_STR}-minimal"

# These are the folders of a debian python installation that we won't need.
PY_CLEAN_DIRS="/usr/share/lintian /usr/share/man /usr/share/pixmaps \
    /usr/share/doc /usr/share/applications"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude deborphan debian-keyring dpkg-dev"

# These options are passed to make because we need to speedup the build.
DEB_BUILD_OPTIONS="parallel=$( nproc ) nocheck nobench"

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

# Python: Download
# ------------------------------------------------------------------------------
# We will use Debian's internal procedure to download the python source code.
# Python ${PY_VER_NUM} source code is available on ${PY_DEBIAN_SUITE}, so
# we will apt-get source it.
# This will give us all the necessary code to build python. Using this method
# is recommended as it was coded by a Debian Developer who already knows what
# he's doing. Not like me.

msginfo "Configuring /etc/apt/sources.list ..."
if [ "${PY_DEBIAN_SUITE}" == "wheezy-security" ]; then
    {
        echo "deb-src ${SECMIRROR} ${PY_DEBIAN_SUITE}/updates main"
    } > /etc/apt/sources.list.d/python-src.list > /dev/null
else
    {
        echo "deb-src ${MIRROR} ${PY_DEBIAN_SUITE} main"
    } > /etc/apt/sources.list.d/python-src.list > /dev/null
fi

cmdretry apt-get update

msginfo "Downloading python source ..."
cd "${PY_SOURCE_TEMPDIR}" && cmdretry apt-get source ${PY_VER_NUM_MINOR_STR}

# This is the only folder that was uncompressed (I hope) by apt-get source.
# We will use it as our base source directory.
PY_SOURCE_DIR="$( ls -1d ${PY_SOURCE_TEMPDIR}/*/ | sed 's|/$||' )"

# Apt: Install build and runtime depends
# ------------------------------------------------------------------------------
# Now we use some shell/apt plumbing to get build depends and runtime depends.

msginfo "Installing python build and runtime dependencies ..."
DPKG_BUILD_DEPENDS="$( apt-get -s build-dep ${PY_VER_NUM_MINOR_STR} | grep "Inst " \
    | awk '{print $2}' | xargs )"
DPKG_RUN_DEPENDS="$( aptitude search -F%p $( printf '~RDepends:~n^%s$ ' ${PY_PKGS} ) \
    | xargs | sed "$( printf 's/\s%s\s/ /g;' ${PY_PKGS} )" )"
DPKG_DEPENDS="$( printf '%s\n' ${DPKG_BUILD_DEPENDS} ${DPKG_RUN_DEPENDS} \
    | uniq | xargs )"
cmdretry apt-get -d install ${DPKG_DEPENDS}
cmdretry apt-get install ${DPKG_DEPENDS}

# Python: Compilation
# ------------------------------------------------------------------------------
# This is the tricky part: we will use the "clean" and "install" targets of the
# debian/rules makefile (which are used to build a debian package) to compile
# our python source code. This will generate a python build tree in the 
# debian folder which we will later process.

msginfo "Compiling python ..."
cd "${PY_SOURCE_DIR}" && \
    DEB_BUILD_OPTIONS="${DEB_BUILD_OPTIONS}" dpkg-buildpackage --no-sign -b -tc

ls -lah "${PY_SOURCE_DIR}"

exit 1

# Python: Installing
# ------------------------------------------------------------------------------
# We will use Pythonz to take care of python compilation for us.

# msginfo "Configuring /etc/apt/sources.list ..."
# # cat > /etc/apt/sources.list.d/libssl.list << EOF
# # deb http://deb.debian.org/debian jessie-backports main
# # deb http://deb.debian.org/debian jessie main
# # EOF

# {
#     echo "deb [trusted=yes] http://ppa.launchpad.net/deadsnakes/ppa/ubuntu ${UBUNTU_RELEASE} main"
# } | tee /etc/apt/sources.list.d/python.list > /dev/null

# msginfo "Installing Python ..."
# cmdretry apt-get update
# cmdretry apt-get -d install ${PY_VER_NUM_MINOR_STR}
# cmdretry apt-get install ${PY_VER_NUM_MINOR_STR}

# # rm -rfv /etc/apt/sources.list.d/libssl.list
# cmdretry apt-get update

# Apt: Remove build depends
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages before installing python
# because some files might be confused with already installed python packages.

msginfo "Removing unnecessary packages ..."
cmdretry apt-get purge $( echo ${DPKG_BUILD_DEPENDS} \
    | sed "$( printf 's/\s%s\s/ /g;' ${DPKG_RUN_DEPENDS} )" )
cmdretry apt-get autoremove

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
rm -rfv "/tmp/"* "/usr/share/doc/"* "/usr/share/locale/"* "/usr/share/man/"* \
        "/var/cache/debconf/"* "/var/cache/apt/"* "/var/tmp/"* "/var/log/"* \
        "/var/lib/apt/lists/"*