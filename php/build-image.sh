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

PHP_VER_NUM_MAJOR="$( echo ${PHP_VER_NUM} | awk -F'.' '{print $1}' )"
PHP_VER_NUM_STR="php${PHP_VER_NUM}"
PHP_VER_NUM_MAJOR_STR="php${PHP_VER_NUM_MAJOR}"

DEBMIRROR="http://deb.debian.org/debian"
SECMIRROR="http://deb.debian.org/debian-security"

# This is the list of php packages from debian that make up a minimal
# php installation. We will use them later.
PHP_PKGS="${PHP_VER_NUM_STR} \
    ${PHP_VER_NUM_STR}-cli \
    ${PHP_VER_NUM_STR}-mbstring"

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

# PHP: Configure sources
# ------------------------------------------------------------------------------
# We will use Debian's repository to install the different versions of PHP.

msginfo "Configuring /etc/apt/sources.list ..."
if [ "${PHP_DEBIAN_SUITE}" == "buster" ]; then
    {
        echo "deb ${DEBMIRROR} buster main"
        echo "deb ${SECMIRROR} buster/updates main"
    } | tee /etc/apt/sources.list.d/php.list > /dev/null
elif [ "${PHP_DEBIAN_SUITE}" == "bullseye" ]; then
    {
        echo "deb ${DEBMIRROR} bullseye main"
    } | tee /etc/apt/sources.list.d/php.list > /dev/null
elif [ "${PHP_DEBIAN_SUITE}" != "sid" ]; then
    {
        echo "deb ${DEBMIRROR} ${PHP_DEBIAN_SUITE} main"
    } | tee /etc/apt/sources.list.d/php.list > /dev/null
fi

cmdretry apt-get update

# PHP: Configure
# ------------------------------------------------------------------------------

mkdir -p /var/www/html
chown www-data:www-data /var/www/html
chmod 777 /var/www/html

# PHP: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${PHP_PKGS}

msginfo "Installing PHP ..."
if [ "${PHP_DEBIAN_SUITE}" == "stretch" ]; then
    cmdretry apt-get install libncurses5 libncursesw5 libtinfo5
elif [ "${PHP_DEBIAN_SUITE}" == "buster" ]; then
    cmdretry apt-get install libncurses6 libncursesw6 libtinfo6
fi
cmdretry apt-get install ${PHP_PKGS} -t ${PHP_DEBIAN_SUITE}
cmdretry apt-get install apache2

# PHP: Configure
# ------------------------------------------------------------------------------

PHP_CONFDIR="/etc/php/conf.d"
APACHE_CONFDIR="/etc/apache2"
APACHE_CONF_AVAILABLE="${APACHE_CONFDIR}/conf-available"
APACHE_ENVVARS="${APACHE_CONFDIR}/envvars"

mkdir -p "${APACHE_CONF_AVAILABLE}" "${PHP_CONFDIR}"

# PHP files should be handled by PHP, and should be preferred over any other file type
{
    echo '<FilesMatch \.php$>'
    echo 'SetHandler application/x-httpd-php'
    echo '</FilesMatch>'
    echo
    echo 'DirectoryIndex disabled'
    echo 'DirectoryIndex index.php index.html'
    echo
    echo '<Directory /var/www/>'
    echo 'Options -Indexes'
    echo 'AllowOverride All'
    echo '</Directory>'
} | tee "${APACHE_CONF_AVAILABLE}/docker-php.conf"

{
    echo 'opcache.memory_consumption=128'
    echo 'opcache.interned_strings_buffer=8'
    echo 'opcache.max_accelerated_files=4000'
    echo 'opcache.revalidate_freq=2'
    echo 'opcache.fast_shutdown=1'
    echo 'opcache.enable_cli=1'
} | tee "${PHP_CONFDIR}/opcache-recommended.ini"

{
    echo 'error_reporting = 4339'
    echo 'display_errors = Off'
    echo 'display_startup_errors = Off'
    echo 'log_errors = On'
    echo 'error_log = /dev/stderr'
    echo 'log_errors_max_len = 1024'
    echo 'ignore_repeated_errors = On'
    echo 'ignore_repeated_source = Off'
    echo 'html_errors = Off'
} | tee "${PHP_CONFDIR}/error-logging.ini"

sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "${APACHE_ENVVARS}"

. "${APACHE_ENVVARS}"

for DIR in "${APACHE_LOCK_DIR}" "${APACHE_RUN_DIR}" "${APACHE_LOG_DIR}"; do
    rm -rvf "${DIR}"
    mkdir -p "${DIR}"
    chown "${APACHE_RUN_USER}:${APACHE_RUN_GROUP}" "${DIR}"
    # allow running as an arbitrary user (https://github.com/docker-library/php/issues/743)
    chmod 777 "${DIR}"
done

# delete the "index.html" that installing Apache drops in here
rm -rvf /var/www/html/*

# logs should go to stdout / stderr
ln -sfT /dev/stderr "${APACHE_LOG_DIR}/error.log"
ln -sfT /dev/stdout "${APACHE_LOG_DIR}/access.log"
ln -sfT /dev/stdout "${APACHE_LOG_DIR}/other_vhosts_access.log"
chown -R --no-dereference "${APACHE_RUN_USER}:${APACHE_RUN_GROUP}" "${APACHE_LOG_DIR}"

a2dismod mpm_event
a2enmod mpm_prefork
a2enmod "${PHP_VER_NUM_STR}"
a2enconf docker-php

# Composer: Installation
# ------------------------------------------------------------------------------
# Let's bring in the artsy composer dude.

msginfo "Installing composer ..."
export HOME="/root/"
curl -fsSL "https://raw.githubusercontent.com/composer/getcomposer.org/master/web/installer" | \
    php -- --install-dir=/usr/local/bin --filename=composer

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

# PHP colors
COLOR_LILAC="\[\033[38;5;105m\]"
COLOR_PURPLE="\[\033[38;5;56m\]"
COLOR_OFF="\[\033[0m\]"
PS1="${COLOR_LILAC}[\u@${COLOR_PURPLE}\h]${COLOR_OFF}:\w\$ "
EOF

cat >> "/etc/skel/.bashrc" << 'EOF'

# PHP colors
COLOR_LILAC="\[\033[38;5;105m\]"
COLOR_PURPLE="\[\033[38;5;56m\]"
COLOR_OFF="\[\033[0m\]"
PS1="${COLOR_LILAC}[\u@${COLOR_PURPLE}\h]${COLOR_OFF}:\w\$ "
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