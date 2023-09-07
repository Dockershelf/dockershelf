#!/usr/bin/env bash
#
# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2022, Dockershelf Developers.

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

NODEMIRROR="https://deb.nodesource.com/node_${NODE_VER_NUM}.x"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="sudo aptitude gnupg dirmngr"
NODE_PKGS="nodejs"
NODE_PKGS_VER=""

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

# Node: Configure sources
# ------------------------------------------------------------------------------
# We will use Nodesource's official repository to install the different versions
# of Node.

msginfo "Configuring /etc/apt/sources.list ..."

if [ "${NODE_VER_NUM}" == "12" ] || [ "${NODE_VER_NUM}" == "14" ]; then
    NODE_DISTRO_NAME="sid"
    NODE_REPO_KEY="1655A0AB68576280"
else
    NODE_DISTRO_NAME="nodistro"
    NODE_REPO_KEY="2F59B5F99B1BE0B4"
fi

cmdretry dirmngr --debug-level guru

cmdretry gpg --lock-never --no-default-keyring \
    --keyring /usr/share/keyrings/node.gpg \
    --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys ${NODE_REPO_KEY}

{
    echo "deb [signed-by=/usr/share/keyrings/node.gpg] ${NODEMIRROR} ${NODE_DISTRO_NAME} main"
} | tee /etc/apt/sources.list.d/node.list >/dev/null

cmdretry apt-get update

# Node: Installation
# ------------------------------------------------------------------------------
# We will use the nodesource script to install node.

msginfo "Installing Node ..."
# if [ "${NODE_VER_NUM}" == "12" ] || [ "${NODE_VER_NUM}" == "14" ]; then
    for PKG in ${NODE_PKGS}; do
        PKG_VER="$(apt-cache madison ${PKG} | grep Packages |
            grep deb.nodesource.com | head -n1 | awk -F'|' '{print $2}' | xargs)"
        NODE_PKGS_VER="${NODE_PKGS_VER} ${PKG}=${PKG_VER}"
    done
    cmdretry aptitude install ${NODE_PKGS_VER}
# else
#     cmdretry aptitude install ${NODE_PKGS}
# fi

if [ ! -f "/usr/bin/nodejs" ]; then
    ln -s /usr/bin/node /usr/bin/nodejs
fi

# Apt: Remove build depends
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages before installing python
# because some files might be confused with already installed python packages.

msginfo "Removing unnecessary packages ..."
cmdretry apt-get purge $(aptitude search -F%p ~c ~g)
cmdretry apt-get purge aptitude
cmdretry apt-get autoremove

# Bash: Changing prompt
# ------------------------------------------------------------------------------
# To distinguish images.

cat >>"/etc/bash.bashrc" <<'EOF'

# Node colors
COLOR_DARK_GREEN="\[\033[38;5;35m\]"
COLOR_LIGHT_GREEN="\[\033[38;5;77m\]"
PS1="${COLOR_LIGHT_GREEN}[\u@${COLOR_DARK_GREEN}\h]${COLOR_OFF}:\w\$ "
EOF

cat >>"/etc/skel/.bashrc" <<'EOF'

# Node colors
COLOR_DARK_GREEN="\[\033[38;5;35m\]"
COLOR_LIGHT_GREEN="\[\033[38;5;77m\]"
PS1="${COLOR_LIGHT_GREEN}[\u@${COLOR_DARK_GREEN}\h]${COLOR_OFF}:\w\$ "
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
