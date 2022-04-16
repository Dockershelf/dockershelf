#!/usr/bin/env bash
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-2022, Dockershelf Developers.
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

RUBY_VER_NUM_MINOR="$( echo ${RUBY_VER_NUM} | awk -F'.' '{print $1"."$2}')"
RUBY_VER_NUM_MAJOR="$( echo ${RUBY_VER_NUM} | awk -F'.' '{print $1}')"
RUBY_VER_NUM_STR="ruby${RUBY_VER_NUM}"
RUBY_VER_NUM_MINOR_STR="ruby${RUBY_VER_NUM_MINOR}"
RUBY_VER_NUM_MAJOR_STR="ruby${RUBY_VER_NUM_MAJOR}"

DEBMIRROR="http://deb.debian.org/debian"
SECMIRROR="http://deb.debian.org/debian-security"

# This is the list of ruby packages from debian that make up a minimal
# ruby installation. We will use them later.
RUBY_PKGS="${RUBY_VER_NUM_STR} ${RUBY_VER_NUM_STR}-dev"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude debian-keyring dpkg-dev gnupg dirmngr"

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

# Ruby: Configure sources
# ------------------------------------------------------------------------------
# We will use Debian's repository to install the different versions of Ruby.

msginfo "Configuring /etc/apt/sources.list ..."
if [ "${RUBY_DEBIAN_SUITE}" == "stretch" ]; then
    {
        echo "deb ${DEBMIRROR} stretch main"
        echo "deb ${SECMIRROR} stretch/updates main"
    } | tee /etc/apt/sources.list.d/ruby.list > /dev/null
elif [ "${RUBY_DEBIAN_SUITE}" == "buster" ]; then
    {
        echo "deb ${DEBMIRROR} buster main"
        echo "deb ${SECMIRROR} buster/updates main"
    } | tee /etc/apt/sources.list.d/ruby.list > /dev/null
elif [ "${RUBY_DEBIAN_SUITE}" != "sid" ]; then
    {
        echo "deb ${DEBMIRROR} ${RUBY_DEBIAN_SUITE} main"
    } | tee /etc/apt/sources.list.d/ruby.list > /dev/null
fi

cmdretry apt-get update

# Ruby: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${RUBY_PKGS}

msginfo "Installing Ruby ..."
if [ "${RUBY_DEBIAN_SUITE}" == "stretch" ]; then
    cmdretry apt-get install libgmp-dev libtinfo5 libncurses5
elif [ "${RUBY_DEBIAN_SUITE}" == "buster" ]; then
    cmdretry apt-get install libgmp-dev libtinfo6 libncurses6
fi
cmdretry apt-get install ${RUBY_PKGS} -t ${RUBY_DEBIAN_SUITE}

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

# Postgres colors
COLOR_DARK_RED="\[\033[38;5;52m\]"
COLOR_LIGHT_RED="\[\033[38;5;88m\]"
PS1="${COLOR_LIGHT_RED}[\u@${COLOR_DARK_RED}\h]${COLOR_OFF}:\w\$ "
EOF

cat >> "/etc/skel/.bashrc" << 'EOF'

# Postgres colors
COLOR_DARK_RED="\[\033[38;5;52m\]"
COLOR_LIGHT_RED="\[\033[38;5;88m\]"
PS1="${COLOR_LIGHT_RED}[\u@${COLOR_DARK_RED}\h]${COLOR_OFF}:\w\$ "
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