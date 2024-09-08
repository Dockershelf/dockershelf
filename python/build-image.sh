#!/usr/bin/env bash
#
# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2023, Dockershelf Developers.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Exit early if there are errors and be verbose.
set -exuo pipefail

# Some default values.
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PYTHON_VER_NUM_MINOR="$(echo ${PYTHON_VER_NUM} | awk -F'.' '{print $1"."$2}')"
PYTHON_VER_NUM_MAJOR="$(echo ${PYTHON_VER_NUM} | awk -F'.' '{print $1}')"
PYTHON_VER_NUM_MINOR_STR="python${PYTHON_VER_NUM_MINOR}"
PYTHON_VER_NUM_MAJOR_STR="python${PYTHON_VER_NUM_MAJOR}"

DEBMIRROR="http://deb.debian.org/debian"
DEADSNAKESPPA="http://ppa.launchpad.net/deadsnakes/ppa/ubuntu"

# This is the list of python packages from debian that make up a minimal
# python installation. We will use them later.
PYTHON_PKGS=" \
    lib${PYTHON_VER_NUM_MINOR_STR}-minimal \
    lib${PYTHON_VER_NUM_MINOR_STR}-stdlib \
    lib${PYTHON_VER_NUM_MINOR_STR}-dev \
    lib${PYTHON_VER_NUM_MINOR_STR} \
    ${PYTHON_VER_NUM_MINOR_STR}-minimal \
    ${PYTHON_VER_NUM_MINOR_STR}-dev \
    ${PYTHON_VER_NUM_MINOR_STR}-distutils \
    ${PYTHON_VER_NUM_MINOR_STR}"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="sudo aptitude gnupg dirmngr"

# Load helper functions
source "${BASEDIR}/library.sh"

# Apt: Install tools
# ------------------------------------------------------------------------------
# We need to install the packages defined at ${DPKG_TOOLS_DEPENDS} because
# some commands are needed to process information before installing
# actual dependencies

msginfo "Installing tools and upgrading image ..."
cmdretry apt-get update
cmdretry apt-get upgrade
cmdretry apt-get install ${DPKG_TOOLS_DEPENDS}

# Python: Configure sources
# ------------------------------------------------------------------------------
# We will use Debian's repository to install the different versions of Python.

msginfo "Configuring /etc/apt/sources.list ..."

cmdretry dirmngr --debug-level guru

cmdretry gpg --lock-never --no-default-keyring \
    --keyring /usr/share/keyrings/python.gpg \
    --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys BA6932366A755776

{
    echo "deb [signed-by=/usr/share/keyrings/python.gpg] ${DEADSNAKESPPA} jammy main"
} | tee /etc/apt/sources.list.d/python.list >/dev/null

{
    echo "deb ${DEBMIRROR} bullseye main"
} | tee /etc/apt/sources.list.d/bullseye.list >/dev/null

# Python: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${PYTHON_PKGS}

msginfo "Installing Python ..."
cmdretry apt-get update
# cmdretry apt-get install libssl1.1 libffi7

if [ "${PYTHON_VER_NUM}" == "3.10" ]; then
    cmdretry apt-get install ${PYTHON_PKGS}
else
    cmdretry apt-get install -t jammy ${PYTHON_PKGS}
fi

if [ "${PYTHON_VER_NUM}" == "3.11" ] || [ "${PYTHON_VER_NUM}" == "3.12" ] || [ "${PYTHON_VER_NUM}" == "3.13" ]; then
    rm -rf /usr/bin/python3
fi

if [ ! -f "/usr/bin/python3" ] && [ -f "/usr/bin/${PYTHON_VER_NUM_MINOR_STR}" ]; then
    ln -s /usr/bin/${PYTHON_VER_NUM_MINOR_STR} /usr/bin/python3
fi

# Pip: Installation
# ------------------------------------------------------------------------------
# Let's bring in the old reliable pip guy.

msginfo "Installing pip ..."

if [ "${PYTHON_VER_NUM}" == "3.7" ]; then
    curl -fsSL "https://bootstrap.pypa.io/pip/3.7/get-pip.py" |
        ${PYTHON_VER_NUM_MINOR_STR} - 'setuptools'
else
    curl -fsSL "https://bootstrap.pypa.io/pip/get-pip.py" |
        ${PYTHON_VER_NUM_MINOR_STR} - 'setuptools'
fi

if [ ! -f "/usr/bin/pip3" ] && [ -f "/usr/bin/pip${PYTHON_VER_NUM_MINOR}" ]; then
    ln -s /usr/bin/pip${PYTHON_VER_NUM_MINOR} /usr/bin/pip3
fi

# Apt: Remove unnecessary packages
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages to shrink image size.

msginfo "Removing unnecessary packages ..."
cmdretry apt-get purge $(aptitude search -F%p ~c ~g)
cmdretry apt-get purge aptitude
cmdretry apt-get autoremove

rm -rf /etc/apt/sources.list.d/bullseye.list
cmdretry apt-get update

# Bash: Changing prompt
# ------------------------------------------------------------------------------
# To distinguish images.

cat >>"/etc/bash.bashrc" <<'EOF'

# Python colors
COLOR_YELLOW="\[\033[38;5;220m\]"
COLOR_BLUE="\[\033[38;5;33m\]"
COLOR_OFF="\[\033[0m\]"
PS1="${COLOR_YELLOW}[\u@${COLOR_BLUE}\h]${COLOR_OFF}:\w\$ "
EOF

cat >>"/etc/skel/.bashrc" <<'EOF'

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
