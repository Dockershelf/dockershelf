#!/usr/bin/env bash
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016-20020, Dockershelf Developers.
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
DEBMIRROR="http://deb.debian.org/debian"
MIRROR="http://nightly.odoo.com/${ODOO_VER_NUM}/nightly/deb/"
WKHTMLTOX_URL="https://github.com/wkhtmltopdf/wkhtmltopdf/"\
"releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude deborphan debian-keyring dpkg-dev gnupg"
ODOO_PKGS="odoo"
ODOO_PKGS_VER=""

# Load helper functions
source "${BASEDIR}/library.sh"

# Apt: Install tools
# ------------------------------------------------------------------------------
# We need to install the packages defined at ${DPKG_TOOLS_DEPENDS} because
# some commands are needed to download and process dependencies

msginfo "Installing tools and upgrading image ..."
cmdretry apt-get update
cmdretry apt-get upgrade -d
cmdretry apt-get upgrade
cmdretry apt-get install -d ${DPKG_TOOLS_DEPENDS}
cmdretry apt-get install ${DPKG_TOOLS_DEPENDS}

# Odoo: Configure sources
# ------------------------------------------------------------------------------
# We will use Odoo's official repository to install the different versions of
# Odoo.

msginfo "Configuring /etc/apt/sources.list ..."
if [ "${ODOO_VER_NUM}" == "9.0" ] || [ "${ODOO_VER_NUM}" == "10.0" ]; then
    {
        echo "deb ${MIRROR} ./"
        echo "deb ${DEBMIRROR} jessie main"
    } | tee /etc/apt/sources.list.d/odoo.list > /dev/null
else
    {
        echo "deb ${MIRROR} ./"
    } | tee /etc/apt/sources.list.d/odoo.list > /dev/null
fi

cmdretry apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv DEF2A2198183CBB5
cmdretry apt-get update

# Apt: Install runtime dependencies
# ------------------------------------------------------------------------------
# Now we use some shell/apt plumbing to get runtime dependencies.

msginfo "Installing odoo runtime dependencies ..."
DPKG_RUN_DEPENDS="$( aptitude search -F%p \
    $( printf '~RDepends:~n^%s$ ' ${ODOO_PKGS} ) | xargs printf ' %s ' | \
    sed "$( printf 's/\s%s\s/ /g;' ${ODOO_PKGS} )" )"
DPKG_DEPENDS="$( printf '%s\n' ${DPKG_RUN_DEPENDS} | \
    uniq | xargs )"

cmdretry apt-get install -d ${DPKG_DEPENDS} sudo nodejs node-less \
    xfonts-75dpi xfonts-base
cmdretry apt-get install ${DPKG_DEPENDS} sudo nodejs node-less \
    xfonts-75dpi xfonts-base

# Installing wkhtmltox
curl -o wkhtmltox.deb -sLO "${WKHTMLTOX_URL}" && \
    dpkg -i wkhtmltox.deb && rm wkhtmltox.deb

# Odoo: Configure
# ------------------------------------------------------------------------------
# We need to configure proper volumes and users.

mkdir -p /mnt/extra-addons /var/log/odoo /var/lib/odoo
groupadd -r odoo
useradd -r -g odoo odoo
chown -R odoo:odoo /mnt/extra-addons /var/log/odoo /var/lib/odoo

# Odoo: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${ODOO_PKGS}

msginfo "Installing Odoo ..."
for PKG in ${ODOO_PKGS}; do
    PKG_VER="$( apt-cache madison ${PKG} | grep Packages | \
        grep nightly.odoo.com | head -n1 | awk -F'|' '{print $2}' | xargs )"
    ODOO_PKGS_VER="${ODOO_PKGS_VER} ${PKG}=${PKG_VER}"
done

cmdretry aptitude install -d ${ODOO_PKGS_VER}
cmdretry aptitude install ${ODOO_PKGS_VER}

# Odoo: Configure
# ------------------------------------------------------------------------------
# Standarize paths.

if [ ! -f "/usr/bin/odoo" ] && [ -f "/usr/bin/openerp-server" ]; then
    ln -s /usr/bin/openerp-server /usr/bin/odoo
fi

ln -s /usr/lib/python${PYTHON_VER_NUM}/dist-packages/odoo/addons /mnt/addons

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

COLOR_LIGHT_PURPLE="\[\033[38;5;131m\]"
COLOR_LIGHT_GRAY="\[\033[38;5;250m\]"
PS1="${COLOR_LIGHT_GRAY}[\u@${COLOR_LIGHT_PURPLE}\h]${COLOR_OFF}:\w\$ "
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