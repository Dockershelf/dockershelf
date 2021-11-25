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

MIRROR="http://deb.debian.org/debian"
NODEMIRROR="https://deb.nodesource.com/node_${NODE_VER_NUM}.x"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude deborphan debian-keyring dpkg-dev gnupg"
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

cmdretry apt-get -d upgrade
cmdretry apt-get upgrade

cmdretry apt-get install -d ${DPKG_TOOLS_DEPENDS}
cmdretry apt-get install ${DPKG_TOOLS_DEPENDS}

# Node: Configure sources
# ------------------------------------------------------------------------------
# We will use Nodesource's official repository to install the different versions
# of Node.

msginfo "Configuring /etc/apt/sources.list ..."

{
    echo "deb ${NODEMIRROR} sid main"
} | tee /etc/apt/sources.list.d/node.list > /dev/null

curl -fsSL "https://deb.nodesource.com/gpgkey/nodesource.gpg.key" | apt-key add -
cmdretry apt-get update

# Apt: Install runtime dependencies
# ------------------------------------------------------------------------------
# Now we use some shell/apt plumbing to get runtime dependencies.

msginfo "Installing node runtime dependencies ..."
DPKG_RUN_DEPENDS="$( aptitude search -F%p \
    $( printf '~RDepends:~n^%s$ ' ${NODE_PKGS} ) | xargs printf ' %s ' | \
    sed "$( printf 's/\s%s\s/ /g;' ${NODE_PKGS} )" )"
DPKG_DEPENDS="$( printf '%s\n' ${DPKG_RUN_DEPENDS} | \
    uniq | xargs | sed 's/libgcc1//g' | sed 's/python-minimal//g' )"

cmdretry apt-get install -d ${DPKG_DEPENDS}
cmdretry apt-get install ${DPKG_DEPENDS}

# Node: Installation
# ------------------------------------------------------------------------------
# We will use the nodesource script to install node.

msginfo "Installing Node ..."
for PKG in ${NODE_PKGS}; do
    PKG_VER="$( apt-cache madison ${PKG} | grep Packages | \
        grep deb.nodesource.com | head -n1 | awk -F'|' '{print $2}' | xargs )"
    NODE_PKGS_VER="${NODE_PKGS_VER} ${PKG}=${PKG_VER}"
done

cmdretry aptitude install -d ${NODE_PKGS_VER}
cmdretry aptitude install ${NODE_PKGS_VER}

if [ ! -f "/usr/bin/nodejs" ]; then
    ln -s /usr/bin/node /usr/bin/nodejs
fi

# Apt: Remove build depends
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages before installing python
# because some files might be confused with already installed python packages.

msginfo "Removing unnecessary packages ..."
# This is clever uh? Figure it out myself, ha!
cmdretry apt-get purge $( apt-mark showauto $( deborphan -a -n \
                            --no-show-section --guess-all --libdevel \
                            -p standard --add-keep "${NODE_PKGS}" ) )
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

# Node colors
COLOR_DARK_GREEN="\[\033[38;5;35m\]"
COLOR_LIGHT_GREEN="\[\033[38;5;77m\]"
PS1="${COLOR_LIGHT_GREEN}[\u@${COLOR_DARK_GREEN}\h]${COLOR_OFF}:\w\$ "
EOF

cat >> "/etc/skel/.bashrc" << 'EOF'

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