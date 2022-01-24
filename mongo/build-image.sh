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

MONGOMIRROR="http://repo.mongodb.org/apt/debian"
DEBMIRROR="http://deb.debian.org/debian"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude debian-keyring dpkg-dev gnupg dirmngr"
MONGO_PKGS="mongodb-org mongodb-org-server mongodb-org-shell \
    mongodb-org-mongos mongodb-org-tools"
MONGO_PKGS_VER=""

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

# Mongo: Configure sources
# ------------------------------------------------------------------------------
# We will use Mongo's official repository to install the different versions of
# Mongo.

msginfo "Configuring /etc/apt/sources.list ..."

cmdretry dirmngr --debug-level guru

if [ "${MONGO_VER_NUM}" == "4.2" ]; then
    cmdretry gpg --lock-never --no-default-keyring \
        --keyring /usr/share/keyrings/mongo.gpg \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 4B7C549A058F8B6B
elif [ "${MONGO_VER_NUM}" == "4.4" ]; then
    cmdretry gpg --lock-never --no-default-keyring \
        --keyring /usr/share/keyrings/mongo.gpg \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 656408E390CFB1F5
elif [ "${MONGO_VER_NUM}" == "5.0" ]; then
    cmdretry gpg --lock-never --no-default-keyring \
        --keyring /usr/share/keyrings/mongo.gpg \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys B00A0BD1E2C63C11
fi

{
    echo "deb ${DEBMIRROR} ${MONGO_DEBIAN_SUITE} main"
    echo "deb [signed-by=/usr/share/keyrings/mongo.gpg] ${MONGOMIRROR} ${MONGO_DEBIAN_SUITE}/mongodb-org/${MONGO_VER_NUM} main"
} | tee /etc/apt/sources.list.d/mongo.list > /dev/null

cmdretry apt-get update

# Mongo: Configure
# ------------------------------------------------------------------------------
# We need to configure proper volumes and users.

groupadd -r mongodb
useradd -r -g mongodb mongodb
mkdir -p /data/db /data/configdb /docker-entrypoint-initdb.d /var/log/mongodb
chown -R mongodb:mongodb /data/db /data/configdb /var/log/mongodb

# Mongo: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${MONGO_PKGS}

msginfo "Installing Mongo ..."
for PKG in ${MONGO_PKGS}; do
    PKG_VER="$( apt-cache madison ${PKG} | grep Packages | \
        grep repo.mongodb.org | head -n1 | awk -F'|' '{print $2}' | xargs )"
    MONGO_PKGS_VER="${MONGO_PKGS_VER} ${PKG}=${PKG_VER}"
done

cmdretry aptitude install ${MONGO_PKGS_VER} libgcc-s1 sudo systemctl jq numactl lsb-base

# Apt: Remove unnecessary packages
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages to shrink image size.

msginfo "Removing unnecessary packages ..."
cmdretry apt-get purge $( aptitude search -F%p ~c ~g )
cmdretry apt-get autoremove

# Bash: Changing prompt
# ------------------------------------------------------------------------------
# To distinguish images.

cat >> "/etc/bash.bashrc" << 'EOF'

# Mongo colors
COLOR_DARK_GREEN="\[\033[38;5;29m\]"
COLOR_LIGHT_GREEN="\[\033[38;5;47m\]"
PS1="${COLOR_LIGHT_GREEN}[\u@${COLOR_DARK_GREEN}\h]${COLOR_OFF}:\w\$ "
EOF

cat >> "/etc/skel/.bashrc" << 'EOF'

# Mongo colors
COLOR_DARK_GREEN="\[\033[38;5;29m\]"
COLOR_LIGHT_GREEN="\[\033[38;5;47m\]"
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