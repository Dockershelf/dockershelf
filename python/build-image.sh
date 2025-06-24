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
# We will use deadsnakes PPA to install the different versions of Python.

msginfo "Configuring /etc/apt/sources.list ..."
msginfo "Using Ubuntu release 'noble' for Python ${PYTHON_VER_NUM_MINOR} on Debian ${PYTHON_DEBIAN_SUITE} ..."

dirmngr --debug-level guru

if [ "${DEBIAN_RELEASE}" == "sid" ]; then
    gpg --no-default-keyring \
        --keyring ./python.gpg \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys BA6932366A755776
    gpg --no-default-keyring \
        --keyring ./python.gpg \
        --armor --export "BA6932366A755776" \
        > /usr/share/keyrings/python.gpg
else
    gpg --no-default-keyring \
        --keyring /usr/share/keyrings/python.gpg \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys BA6932366A755776
fi

UBUNTU_RELEASE="noble"
if [ "${PYTHON_VER_NUM_MINOR}" == "3.7" ] || [ "${PYTHON_VER_NUM_MINOR}" == "3.10" ] || [ "${PYTHON_VER_NUM_MINOR}" == "3.11" ]; then
    PYTHON_PKGS="${PYTHON_PKGS} ${PYTHON_VER_NUM_MINOR_STR}-distutils lib${PYTHON_VER_NUM_MINOR_STR}-minimal ${PYTHON_VER_NUM_MINOR_STR}-minimal"
    UBUNTU_RELEASE="focal"
elif [ "${PYTHON_VER_NUM_MINOR}" == "3.12" ] || [ "${PYTHON_VER_NUM_MINOR}" == "3.13" ]; then
    UBUNTU_RELEASE="jammy"
fi

{
    echo "deb [signed-by=/usr/share/keyrings/python.gpg] ${DEADSNAKESPPA} ${UBUNTU_RELEASE} main"
} | tee /etc/apt/sources.list.d/python.list >/dev/null

apt-get update

# Python: Install missing dependencies from Bullseye
# ------------------------------------------------------------------------------
# Python 3.7, 3.10, and 3.11 require libssl1.1 and libffi7 which are only
# available in Debian Bullseye. We temporarily add the repository to install them.

if [ "${PYTHON_VER_NUM_MINOR}" == "3.7" ] || [ "${PYTHON_VER_NUM_MINOR}" == "3.10" ] || [ "${PYTHON_VER_NUM_MINOR}" == "3.11" ]; then
    msginfo "Installing missing dependencies from Debian Bullseye for Python ${PYTHON_VER_NUM_MINOR} ..."
    
    # Add Debian Bullseye repository temporarily
    {
        echo "deb ${DEBMIRROR} bullseye main"
    } | tee /etc/apt/sources.list.d/bullseye.list >/dev/null
    
    apt-get update
    
    # Install the required packages with specific priorities to avoid conflicts
    apt-get install -y -t bullseye libssl1.1 libffi7
    
    # Remove Bullseye repository
    rm -f /etc/apt/sources.list.d/bullseye.list
    apt-get update
    
    msginfo "Successfully installed missing dependencies from Bullseye"
fi

# Python: Installation
# ------------------------------------------------------------------------------
# We will use deadsnakes PPA to install Python binary packages.

msginfo "Installing Python ${PYTHON_VER_NUM} ..."

# Get specific package versions from deadsnakes PPA
for PKG in ${PYTHON_PKGS}; do
    PKG_VER="$(apt-cache madison ${PKG} | grep Packages |
        grep ppa.launchpad.net | head -n1 | awk -F'|' '{print $2}' | xargs || true)"
    if [ -n "${PKG_VER}" ]; then
        PYTHON_PKGS_VER="${PYTHON_PKGS_VER} ${PKG}=${PKG_VER}"
    else
        # If no specific version found, install latest available
        PYTHON_PKGS_VER="${PYTHON_PKGS_VER} ${PKG}"
    fi
done

# Handle potential conflicts with system packages on sid
if [ "${DEBIAN_RELEASE}" == "sid" ]; then
    # Install media-types first (replaces mime-support in sid)
    aptitude install -y media-types || true
    
    # Create a dummy mime-support package to satisfy deadsnakes PPA dependencies
    # This is needed because deadsnakes packages still depend on mime-support
    # but Debian sid replaced it with media-types
    apt-get install -y equivs
    
    cat > /tmp/mime-support-dummy.control << 'EOF'
Section: misc
Priority: optional
Standards-Version: 3.9.2
Package: mime-support
Version: 999.999.999
Maintainer: Dockershelf <dockershelf@dockershelf.com>
Architecture: all
Provides: mime-support
Replaces: mime-support
Conflicts: mime-support
Description: Dummy package to replace mime-support
 This is a dummy package that provides mime-support functionality
 through the media-types package that is already installed.
 .
 This package is created to satisfy dependencies from deadsnakes PPA
 packages that still depend on the old mime-support package name.
EOF

    equivs-build /tmp/mime-support-dummy.control
    dpkg -i mime-support*.deb
    
    # Clean up
    rm -f /tmp/mime-support-dummy.control /tmp/mime-support*.deb
    apt-get purge -y equivs
    apt-get autoremove -y
fi

# Install Python packages
aptitude install ${PYTHON_PKGS_VER}

ls -lah /usr/bin/python*

# Create python3 symlink if needed
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
