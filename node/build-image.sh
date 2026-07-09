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

NODEMIRROR="https://apt.dockershelf.com/dockershelf"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="sudo aptitude gnupg dirmngr"
NODE_PKGS="nodejs-${NODE_VER_NUM}"
NODE_PKGS_VER=""

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

# Node: Configure sources
# ------------------------------------------------------------------------------
# We will use the Dockershelf APT repository at apt.dockershelf.com to
# install the different versions of Node.

msginfo "Configuring /etc/apt/sources.list ..."

# Detect the Debian suite at runtime and map sid -> unstable, as the
# Dockershelf APT repo uses "unstable" as the codename for sid packages.
DEBIAN_SUITE="$(. /etc/os-release && echo "${VERSION_CODENAME}")"
if [ "${DEBIAN_SUITE}" = "sid" ]; then
    DEBIAN_SUITE="unstable"
fi

curl -fsSL "${NODEMIRROR}/key.gpg" \
    | gpg --dearmor > /usr/share/keyrings/node.gpg

{
    echo "deb [signed-by=/usr/share/keyrings/node.gpg] ${NODEMIRROR} ${DEBIAN_SUITE} main"
} | tee /etc/apt/sources.list.d/node.list >/dev/null

apt-get update

# Node: Installation
# ------------------------------------------------------------------------------
# We will install the versioned nodejs-XX package from the Dockershelf APT
# repository.

msginfo "Installing Node ..."
for PKG in ${NODE_PKGS}; do
    PKG_VER="$(apt-cache madison ${PKG} | grep Packages |
        grep apt.dockershelf.com | head -n1 | awk -F'|' '{print $2}' | xargs || true)"
    NODE_PKGS_VER="${NODE_PKGS_VER} ${PKG}=${PKG_VER}"
done

aptitude install ${NODE_PKGS_VER}

if [ ! -f "/usr/bin/nodejs" ]; then
    ln -s /usr/bin/node /usr/bin/nodejs
fi

# Apt: Remove build depends
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages before installing python
# because some files might be confused with already installed python packages.

msginfo "Removing unnecessary packages ..."
apt-get purge $(aptitude search -F%p ~c ~g)
apt-get purge aptitude
apt-get autoremove

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
