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
MIRROR="http://apt.postgresql.org/pub/repos/apt"
DEBMIRROR="http://deb.debian.org/debian"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude deborphan debian-keyring dpkg-dev gnupg"
POSTGRES_PKGS="postgresql-${POSTGRES_VER_NUM} \
    postgresql-client-${POSTGRES_VER_NUM} postgresql-common \
    postgresql-client-common"
POSTGRES_PKGS_VER=""

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

# Postgres: Configure sources
# ------------------------------------------------------------------------------
# We will use Postgres's official repository to install the different versions
# of Postgres.

msginfo "Configuring /etc/apt/sources.list ..."
{
    echo "deb ${MIRROR} sid-pgdg main ${POSTGRES_VER_NUM}"
} | tee /etc/apt/sources.list.d/postgres.list > /dev/null

cmdretry apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
cmdretry apt-get update

# Postgres: Configure
# ------------------------------------------------------------------------------
# We need to configure proper volumes and users.

groupadd -r postgres --gid=999
useradd -r -g postgres --uid=999 postgres
mkdir /docker-entrypoint-initdb.d
mkdir -p /var/lib/postgresql/data /var/run/postgresql
chown -R postgres:postgres /var/lib/postgresql/data /var/run/postgresql
chmod 2777 /var/run/postgresql
chmod 777 /var/lib/postgresql/data

# Apt: Install runtime dependencies
# ------------------------------------------------------------------------------
# Now we use some shell/apt plumbing to get runtime dependencies.

msginfo "Installing postgres runtime dependencies ..."
DPKG_RUN_DEPENDS="$( aptitude search -F%p \
    $( printf '~RDepends:~n^%s$ ' ${POSTGRES_PKGS} ) | xargs printf ' %s ' | \
    sed "$( printf 's/\s%s\s/ /g;' ${POSTGRES_PKGS} )" )"
DPKG_DEPENDS="$( printf '%s\n' ${DPKG_RUN_DEPENDS} | uniq | xargs )"

cmdretry aptitude install -d ${DPKG_DEPENDS} libnss-wrapper sudo
cmdretry aptitude install ${DPKG_DEPENDS} libnss-wrapper sudo

# Postgres: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${POSTGRES_PKGS}

msginfo "Installing Postgres ..."
for PKG in ${POSTGRES_PKGS}; do
    PKG_VER="$( apt-cache madison ${PKG} | grep Packages | \
        grep apt.postgresql.org | head -n1 | awk -F'|' '{print $2}' | xargs )"
    POSTGRES_PKGS_VER="${POSTGRES_PKGS_VER} ${PKG}=${PKG_VER}"
done

cmdretry aptitude install -d ${POSTGRES_PKGS_VER}
cmdretry aptitude install ${POSTGRES_PKGS_VER}
cmdretry apt-mark manual ${POSTGRES_PKGS}

# Postgres: Configure
# ------------------------------------------------------------------------------
# Make the sample config easier to munge (and "correct by default")

mv -v "/usr/share/postgresql/${POSTGRES_VER_NUM}/postgresql.conf.sample" \
    /usr/share/postgresql/
ln -sv ../postgresql.conf.sample "/usr/share/postgresql/${POSTGRES_VER_NUM}/"
sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" \
    /usr/share/postgresql/postgresql.conf.sample

# Apt: Remove unnecessary packages
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages to shrink image size.

msginfo "Removing unnecessary packages ..."
# This is clever uh? Figure it out myself, ha!
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

# Postgres colors
COLOR_DARK_BLUE="\[\033[38;5;26m\]"
COLOR_LIGHT_BLUE="\[\033[38;5;75m\]"
PS1="${COLOR_LIGHT_BLUE}[\u@${COLOR_DARK_BLUE}\h]${COLOR_OFF}:\w\$ "
EOF

cat >> "/etc/skel/.bashrc" << 'EOF'

# Postgres colors
COLOR_DARK_BLUE="\[\033[38;5;26m\]"
COLOR_LIGHT_BLUE="\[\033[38;5;75m\]"
PS1="${COLOR_LIGHT_BLUE}[\u@${COLOR_DARK_BLUE}\h]${COLOR_OFF}:\w\$ "
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