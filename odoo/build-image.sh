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

DEBMIRROR="http://deb.debian.org/debian"
ODOOMIRROR="http://nightly.odoo.com/${ODOO_VER_NUM}/nightly/deb/"
WKHTMLTOX_URL="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="sudo aptitude gnupg dirmngr"
ODOO_PKGS="odoo"
ODOO_PKGS_VER=""

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

# Odoo: Configure sources
# ------------------------------------------------------------------------------
# We will use Odoo's official repository to install the different versions of
# Odoo.

msginfo "Configuring /etc/apt/sources.list ..."

cmdretry dirmngr --debug-level guru

cmdretry gpg --lock-never --no-default-keyring \
    --keyring /usr/share/keyrings/odoo.gpg \
    --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys DEF2A2198183CBB5

{
    echo "deb [signed-by=/usr/share/keyrings/odoo.gpg] ${ODOOMIRROR} ./"
} | tee /etc/apt/sources.list.d/odoo.list > /dev/null

{
    echo "deb ${DEBMIRROR} bullseye main"
} | tee /etc/apt/sources.list.d/bullseye.list > /dev/null

cmdretry apt-get update

# Apt: Install runtime dependencies
# ------------------------------------------------------------------------------
# Now we use some shell/apt plumbing to get runtime dependencies.

# Installing dependencies
cmdretry apt-get install \
    fontconfig \
    libfreetype6 \
    libjpeg62-turbo \
    libpng16-16 \
    libx11-6 \
    libxcb1 \
    libxext6 \
    libxrender1 \
    xfonts-75dpi \
    xfonts-base \
    ca-certificates \
    curl \
    fonts-noto-cjk \
    libssl-dev \
    node-less \
    npm \
    postgresql-client \
    python3-num2words \
    python3-pdfminer \
    python3-pip \
    python3-phonenumbers \
    python3-pyldap \
    python3-qrcode \
    python3-renderpm \
    python3-setuptools \
    python3-slugify \
    python3-vobject \
    python3-watchdog \
    python3-xlrd \
    python3-xlwt \
    xz-utils

cmdretry apt-get install python3-vatnumber -t bullseye

# Installing wkhtmltox
curl -o wkhtmltox.deb -sLO "${WKHTMLTOX_URL}" && \
    dpkg -i wkhtmltox.deb && rm wkhtmltox.deb

npm install -g rtlcss

# Odoo: Configure
# ------------------------------------------------------------------------------
# We need to configure proper volumes and users.

groupadd -r odoo
useradd -r -g odoo odoo

mkdir -p /mnt/extra-addons /var/log/odoo /var/lib/odoo
chown -R odoo:odoo /mnt/extra-addons /var/log/odoo /var/lib/odoo /etc/odoo/odoo.conf

# Odoo: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${ODOO_PKGS}

msginfo "Installing Odoo ..."
for PKG in ${ODOO_PKGS}; do
    PKG_VER="$( apt-cache madison ${PKG} | grep Packages | \
        grep nightly.odoo.com | head -n1 | awk -F'|' '{print $2}' | xargs )"
    ODOO_PKGS_VER="${ODOO_PKGS_VER} ${PKG}=${PKG_VER}"
done

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
cmdretry apt-get purge $( aptitude search -F%p ~c ~g )
cmdretry apt-get purge aptitude
cmdretry apt-get autoremove

rm -rf /etc/apt/sources.list.d/bullseye.list
cmdretry apt-get update

# Bash: Changing prompt
# ------------------------------------------------------------------------------
# To distinguish images.

cat >> "/etc/bash.bashrc" << 'EOF'

# Odoo colors
COLOR_LIGHT_PURPLE="\[\033[38;5;131m\]"
COLOR_LIGHT_GRAY="\[\033[38;5;250m\]"
PS1="${COLOR_LIGHT_GRAY}[\u@${COLOR_LIGHT_PURPLE}\h]${COLOR_OFF}:\w\$ "
EOF

cat >> "/etc/skel/.bashrc" << 'EOF'

# Odoo colors
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