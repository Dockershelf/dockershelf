#!/usr/bin/env bash
#
# Please refer to AUTHORS.md for a complete list of Copyright holders.
# Copyright (C) 2016-2023, Dockershelf Developers.

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
ARCHITECTURE="$(dpkg --print-architecture)"

GO_VER_NUM_PATCH="$(echo ${GO_VER_NUM} | awk -F'.' '{print $1"."$2"."$3}')"
GO_VER_NUM_MINOR="$(echo ${GO_VER_NUM} | awk -F'.' '{print $1"."$2}')"
GO_VER_NUM_MAJOR="$(echo ${GO_VER_NUM} | awk -F'.' '{print $1}')"
GO_VER_NUM_PATCH_STR="go${GO_VER_NUM_PATCH}"
GO_VER_NUM_MINOR_STR="go${GO_VER_NUM_MINOR}"
GO_VER_NUM_MAJOR_STR="go${GO_VER_NUM_MAJOR}"

GO_DOWNLOAD_URL="https://go.dev/dl/${GO_VER_NUM_PATCH_STR}.linux-${ARCHITECTURE}.tar.gz"

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

# Go: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${GO_PKGS}

msginfo "Installing Go ..."
curl -L "${GO_DOWNLOAD_URL}" -o ${GO_VER_NUM_PATCH_STR}.linux-${ARCHITECTURE}.tar.gz
tar -C /usr/local -xzf ${GO_VER_NUM_PATCH_STR}.linux-${ARCHITECTURE}.tar.gz
rm -rf ${GO_VER_NUM_PATCH_STR}.linux-${ARCHITECTURE}.tar.gz

if [ ! -f "/usr/bin/go" ] && [ -f "/usr/local/go/bin/${GO_VER_NUM_PATCH_STR}" ]; then
    ln -s /usr/local/go/bin/${GO_VER_NUM_MINOR_STR} /usr/bin/go
fi

# Apt: Remove unnecessary packages
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages to shrink image size.

msginfo "Removing unnecessary packages ..."
cmdretry apt-get purge $(aptitude search -F%p ~c ~g)
cmdretry apt-get purge aptitude
cmdretry apt-get autoremove

# Bash: Changing prompt
# ------------------------------------------------------------------------------
# To distinguish images.

cat >>"/etc/bash.bashrc" <<'EOF'

# Go colors
COLOR_CYAN="\[\033[38;5;81m\]"
COLOR_WHITE="\[\033[38;5;231m\]"
COLOR_OFF="\[\033[0m\]"
PS1="${COLOR_CYAN}[\u@${COLOR_WHITE}\h]${COLOR_OFF}:\w\$ "
EOF

cat >>"/etc/skel/.bashrc" <<'EOF'

# Go colors
COLOR_CYAN="\[\033[38;5;81m\]"
COLOR_WHITE="\[\033[38;5;231m\]"
COLOR_OFF="\[\033[0m\]"
PS1="${COLOR_CYAN}[\u@${COLOR_WHITE}\h]${COLOR_OFF}:\w\$ "
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
