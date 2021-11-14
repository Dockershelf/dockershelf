#!/usr/bin/env bash
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-2020, Dockershelf Developers.
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

PYTHON_VER_NUM_MINOR="$( echo ${PYTHON_VER_NUM} | awk -F'.' '{print $1"."$2}')"
PYTHON_VER_NUM_MAJOR="$( echo ${PYTHON_VER_NUM} | awk -F'.' '{print $1}')"
PYTHON_VER_NUM_MINOR_STR="python${PYTHON_VER_NUM_MINOR}"
PYTHON_VER_NUM_MAJOR_STR="python${PYTHON_VER_NUM_MAJOR}"

MIRROR="http://deb.debian.org/debian"
UBUNTUMIRROR="http://archive.ubuntu.com/ubuntu"
UBUNTUSECMIRROR="http://security.ubuntu.com/ubuntu"

# This is the list of python packages from debian that make up a minimal
# python installation. We will use them later.
PYTHON_PKGS="lib${PYTHON_VER_NUM_MINOR_STR}-minimal \
    ${PYTHON_VER_NUM_MINOR_STR}-minimal \
    lib${PYTHON_VER_NUM_MINOR_STR}-stdlib \
    lib${PYTHON_VER_NUM_MINOR_STR} ${PYTHON_VER_NUM_MINOR_STR} \
    lib${PYTHON_VER_NUM_MINOR_STR}-dev ${PYTHON_VER_NUM_MINOR_STR}-dev"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude deborphan debian-keyring dpkg-dev gnupg git"

# Load helper functions
source "${BASEDIR}/library.sh"

# Apt: Install tools
# ------------------------------------------------------------------------------
# We need to install the packages defined at ${DPKG_TOOLS_DEPENDS} because
# some commands are needed to process information before installing
# actual dependencies

msginfo "Installing tools and upgrading image ..."
cmdretry apt-get update

cmdretry apt-get -d upgrade
cmdretry apt-get upgrade

cmdretry apt-get install -d ${DPKG_TOOLS_DEPENDS}
cmdretry apt-get install ${DPKG_TOOLS_DEPENDS}

# Python: Configure sources
# ------------------------------------------------------------------------------
# We will use Debian's repository to install the different versions of Python.

msginfo "Configuring /etc/apt/sources.list ..."
if [ "${PYTHON_DEBIAN_SUITE}" != "sid" ]; then
    {
        echo "deb ${MIRROR} ${PYTHON_DEBIAN_SUITE} main"
    } | tee /etc/apt/sources.list.d/python.list > /dev/null
fi

if [ "${PYTHON_VER_NUM}" == "3.6" ]; then
    cmdretry apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
    {
        echo "deb ${UBUNTUMIRROR} bionic main"
        echo "deb ${UBUNTUSECMIRROR} bionic-security main universe"
    } | tee /etc/apt/sources.list.d/ubuntu.list > /dev/null
elif [ "${PYTHON_VER_NUM}" == "3.8" ]; then
    cmdretry apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C
    {
        echo "deb ${UBUNTUMIRROR} groovy main"
        echo "deb ${UBUNTUSECMIRROR} groovy-security main universe"
    } | tee /etc/apt/sources.list.d/ubuntu.list > /dev/null
    cmdretry apt-get update
    cmdretry apt-get install --allow-downgrades libc6/groovy libc6-dev/groovy libc-dev-bin/groovy
fi

cmdretry apt-get update

# Apt: Install runtime dependencies
# ------------------------------------------------------------------------------
# Now we use some shell/apt plumbing to get runtime dependencies.

msginfo "Installing python runtime dependencies ..."
DPKG_RUN_DEPENDS="$( aptitude search -F%p \
    $( printf '~RDepends:~n^%s$ ' ${PYTHON_PKGS} ) | xargs printf ' %s ' | \
    sed "$( printf 's/\s%s\s/ /g;' ${PYTHON_PKGS} )" )"
DPKG_DEPENDS="$( printf '%s\n' ${DPKG_RUN_DEPENDS} | uniq | xargs )"

if [ "${PYTHON_VER_NUM}" == "3.8" ]; then
    DPKG_DEPENDS="$( echo ${DPKG_DEPENDS} | sed 's/libc6-dev//g' | \
    sed 's/libc6//g' | sed 's/libc-dev-bin//g' | sed 's/libffi8ubuntu1//g'  )"
fi

cmdretry apt-get install -d ${DPKG_DEPENDS}
cmdretry apt-get install ${DPKG_DEPENDS}

# Python: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${PYTHON_PKGS}

msginfo "Installing Python ..."
cmdretry aptitude install ${PYTHON_PKGS}
cmdretry apt-get install -d ${PYTHON_PKGS}
cmdretry apt-get install ${PYTHON_PKGS}

if [ ! -f "/usr/bin/python" ]; then
    ln -s /usr/bin/${PYTHON_VER_NUM_MINOR_STR} /usr/bin/python
fi

if [ "${PYTHON_VER_NUM}" == "3.6" ]; then
    cmdretry apt-get install -d ${PYTHON_VER_NUM_MAJOR_STR}-distutils -t bionic
    cmdretry apt-get install ${PYTHON_VER_NUM_MAJOR_STR}-distutils -t bionic
    rm -rfv "/etc/apt/sources.list.d/ubuntu.list"
    cmdretry apt-get update
elif [ "${PYTHON_VER_NUM}" == "3.8" ]; then
    cmdretry apt-get install -d ${PYTHON_VER_NUM_MAJOR_STR}-distutils -t groovy
    cmdretry apt-get install ${PYTHON_VER_NUM_MAJOR_STR}-distutils -t groovy
    rm -rfv "/etc/apt/sources.list.d/ubuntu.list"
    cmdretry apt-get update
elif [ "${PYTHON_VER_NUM}" == "3.9" ]; then
    cmdretry apt-get install -d ${PYTHON_VER_NUM_MAJOR_STR}-distutils -t bookworm
    cmdretry apt-get install ${PYTHON_VER_NUM_MAJOR_STR}-distutils -t bookworm
elif [ "${PYTHON_VER_NUM}" == "3.10" ]; then
    git clone https://github.com/pypa/distutils
    cp -r distutils/distutils/* /usr/lib/python3.10/distutils/
fi

# Pip: Installation
# ------------------------------------------------------------------------------
# Let's bring in the old reliable pip guy.

msginfo "Installing pip ..."

if [ "${PYTHON_VER_NUM}" == "2.7" ]; then
    curl -fsSL "https://bootstrap.pypa.io/pip/2.7/get-pip.py" | \
        ${PYTHON_VER_NUM_MINOR_STR} - 'setuptools'
elif [ "${PYTHON_VER_NUM}" == "3.5" ]; then
    curl -fsSL "https://bootstrap.pypa.io/pip/3.5/get-pip.py" | \
        ${PYTHON_VER_NUM_MINOR_STR} - 'setuptools'
else
    curl -fsSL "https://bootstrap.pypa.io/pip/get-pip.py" | \
        ${PYTHON_VER_NUM_MINOR_STR} - 'setuptools'
fi

if [ ! -f "/usr/bin/pip" ]; then
    ln -s /usr/bin/pip${PYTHON_VER_NUM} /usr/bin/pip
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

# Bash: Changing prompt
# ------------------------------------------------------------------------------
# To distinguish images.

cat >> "/etc/bash.bashrc" << 'EOF'

# Python colors
COLOR_YELLOW="\[\033[38;5;220m\]"
COLOR_BLUE="\[\033[38;5;33m\]"
COLOR_OFF="\[\033[0m\]"
PS1="${COLOR_YELLOW}[\u@${COLOR_BLUE}\h]${COLOR_OFF}:\w\$ "
EOF

cat >> "/etc/skel/.bashrc" << 'EOF'

# Python colors
COLOR_YELLOW="\[\033[38;5;220m\]"
COLOR_BLUE="\[\033[38;5;33m\]"
COLOR_OFF="\[\033[0m\]"
PS1="${COLOR_YELLOW}[\u@${COLOR_BLUE}\h]${COLOR_OFF}:\w\$ "
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