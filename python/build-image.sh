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

PYTHONMIRROR="https://apt.dockershelf.com/dockershelf"

# This is the list of python packages from debian that make up a minimal
# python installation. We will use them later.
PYTHON_PKGS=" \
    lib${PYTHON_VER_NUM_MINOR_STR}-stdlib \
    lib${PYTHON_VER_NUM_MINOR_STR}-dev \
    lib${PYTHON_VER_NUM_MINOR_STR} \
    ${PYTHON_VER_NUM_MINOR_STR}-dev \
    ${PYTHON_VER_NUM_MINOR_STR}"
PYTHON_PKGS_VER=""

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
apt-get update
apt-get upgrade
apt-get install ${DPKG_TOOLS_DEPENDS}

# Python: Configure sources
# ------------------------------------------------------------------------------
# We will use the Dockershelf APT repository at apt.dockershelf.com to
# install the different versions of Python.

msginfo "Configuring /etc/apt/sources.list ..."
msginfo "Using Dockershelf APT repo for Python ${PYTHON_VER_NUM_MINOR} on Debian ${PYTHON_DEBIAN_SUITE} ..."

# Detect the Debian suite at runtime and map sid -> unstable, as the
# Dockershelf APT repo uses "unstable" as the codename for sid packages.
DEBIAN_SUITE="${PYTHON_DEBIAN_SUITE}"
if [ "${DEBIAN_SUITE}" = "sid" ]; then
    DEBIAN_SUITE="unstable"
fi

curl -fsSL "${PYTHONMIRROR}/dockershelf-apt-signing.pub" \
    | gpg --dearmor > /usr/share/keyrings/python.gpg

{
    echo "deb [signed-by=/usr/share/keyrings/python.gpg] ${PYTHONMIRROR} ${DEBIAN_SUITE} main"
} | tee /etc/apt/sources.list.d/python.list >/dev/null

apt-get update

# Python: Installation
# ------------------------------------------------------------------------------
# We will install the versioned python3.X packages from the Dockershelf APT
# repository.

msginfo "Installing Python ${PYTHON_VER_NUM} ..."

# Get specific package versions from the Dockershelf APT repository
for PKG in ${PYTHON_PKGS}; do
    PKG_VER="$(apt-cache madison ${PKG} | grep Packages |
        grep apt.dockershelf.com | head -n1 | awk -F'|' '{print $2}' | xargs || true)"
    if [ -n "${PKG_VER}" ]; then
        PYTHON_PKGS_VER="${PYTHON_PKGS_VER} ${PKG}=${PKG_VER}"
    else
        # If no specific version found, install latest available
        PYTHON_PKGS_VER="${PYTHON_PKGS_VER} ${PKG}"
    fi
done

# Install Python packages
aptitude install ${PYTHON_PKGS_VER}

ls -lah /usr/bin/python*

# Create python3 symlink
ln -sf /usr/bin/${PYTHON_VER_NUM_MINOR_STR} /usr/bin/python3

# Pip: Installation
# ------------------------------------------------------------------------------
# Let's bring in the old reliable pip guy.

msginfo "Installing pip ..."

curl -fsSL "https://bootstrap.pypa.io/pip/get-pip.py" |
    ${PYTHON_VER_NUM_MINOR_STR} - 'setuptools'

if [ ! -f "/usr/bin/pip3" ] && [ -f "/usr/bin/pip${PYTHON_VER_NUM_MINOR}" ]; then
    ln -s /usr/bin/pip${PYTHON_VER_NUM_MINOR} /usr/bin/pip3
fi

# Apt: Remove unnecessary packages
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages to shrink image size.

msginfo "Removing unnecessary packages ..."
apt-get purge $(aptitude search -F%p ~c ~g)
apt-get purge aptitude
apt-get autoremove

rm -rf /etc/apt/sources.list.d/python.list
apt-get update

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
