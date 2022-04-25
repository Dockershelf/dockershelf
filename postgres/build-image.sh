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
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PGMIRROR="http://apt.postgresql.org/pub/repos/apt"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="sudo aptitude gnupg dirmngr"
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
cmdretry apt-get upgrade
cmdretry apt-get install ${DPKG_TOOLS_DEPENDS}

# Postgres: Configure sources
# ------------------------------------------------------------------------------
# We will use Postgres's official repository to install the different versions
# of Postgres.

msginfo "Configuring /etc/apt/sources.list ..."

cmdretry dirmngr --debug-level guru

cmdretry gpg --lock-never --no-default-keyring \
    --keyring /usr/share/keyrings/postgres.gpg \
    --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

{
    echo "deb [signed-by=/usr/share/keyrings/postgres.gpg] ${PGMIRROR} sid-pgdg main ${POSTGRES_VER_NUM}"
} | tee /etc/apt/sources.list.d/postgres.list > /dev/null

cmdretry apt-get update

# Apt: Install runtime dependencies
# ------------------------------------------------------------------------------
# Now we use some shell/apt plumbing to get runtime dependencies.

cat > "${TARGET}/usr/share/dockershelf/clean-dpkg.sh" << 'EOF'
#!/usr/bin/env bash
# Dockershelf post hook for dpkg
find /usr -name "*.py[co]" -print0 | xargs -0r rm -rf
find /usr -name "__pycache__" -type d -print0 | xargs -0r rm -rf
EOF

# Installing dependencies
cmdretry apt-get install \
    gosu \
    libnss-wrapper \
    xz-utils \
    zstd \
    locales

localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
update-locale LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"

# Postgres: Configure
# ------------------------------------------------------------------------------
# We need to configure proper volumes and users.

groupadd -r postgres --gid=999
useradd -r -g postgres --uid=999 --home-dir=/var/lib/postgresql --shell=/bin/bash postgres

mkdir -p /var/lib/postgresql/data /var/run/postgresql /docker-entrypoint-initdb.d
chown -R postgres:postgres /var/lib/postgresql/data /var/run/postgresql
chmod 2777 /var/run/postgresql
chmod 777 /var/lib/postgresql/data

# Postgres: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${POSTGRES_PKGS}

msginfo "Installing Postgres ..."
for PKG in ${POSTGRES_PKGS}; do
    PKG_VER="$( apt-cache madison ${PKG} | grep Packages | \
        grep apt.postgresql.org | head -n1 | awk -F'|' '{print $2}' | xargs )"
    POSTGRES_PKGS_VER="${POSTGRES_PKGS_VER} ${PKG}=${PKG_VER}"
done

cmdretry aptitude install ${POSTGRES_PKGS_VER} libnss-wrapper sudo

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
cmdretry apt-get purge $( aptitude search -F%p ~c ~g )
cmdretry apt-get purge aptitude
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
rm -rfv "/tmp/"* "/usr/share/doc/"* "/usr/share/man/"* \
        "/var/cache/debconf/"* "/var/cache/apt/"* "/var/tmp/"* "/var/log/"* \
        "/var/lib/apt/lists/"*