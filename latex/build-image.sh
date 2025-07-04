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
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Some tools are needed.
DPKG_TOOLS_DEPENDS="sudo aptitude gnupg dirmngr"

# Latex packages
if [ "${LATEX_VER_NUM}" == "basic" ]; then
    LATEX_PKGS="texlive-fonts-recommended texlive-latex-base texlive-latex-extra \
        texlive-latex-recommended"
else
    LATEX_PKGS="asymptote biber chktex cm-super context dvidvi dvipng \
        feynmf fragmaster info lacheck latex-cjk-all latexdiff \
        latexmk lcdf-typetools lmodern prerex psutils purifyeps \
        t1utils tex-gyre texinfo texlive-base texlive-bibtex-extra \
        texlive-binaries texlive-extra-utils texlive-formats-extra \
        texlive-games texlive-humanities texlive-lang-english \
        texlive-latex-base texlive-latex-extra texlive-latex-recommended \
        texlive-luatex texlive-metapost texlive-music texlive-pictures \
        texlive-plain-generic texlive-pstricks texlive-publishers \
        texlive-science texlive-xetex tipa vprerex"
fi

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

# Latex: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${LATEX_PKGS}

msginfo "Installing Latex ..."
apt-get install ${LATEX_PKGS} python3-pygments

# Apt: Remove unnecessary packages
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages to shrink image size.

msginfo "Removing unnecessary packages ..."
apt-get purge $( aptitude search -F%p ~c ~g )
apt-get purge aptitude
apt-get autoremove

# Bash: Changing prompt
# ------------------------------------------------------------------------------
# To distinguish images.

cat >> "/etc/bash.bashrc" << 'EOF'

# Latex colors
PS1="[\u@\h]:\w\$ "
EOF

cat >> "/etc/skel/.bashrc" << 'EOF'

# Latex colors
PS1="[\u@\h]:\w\$ "
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