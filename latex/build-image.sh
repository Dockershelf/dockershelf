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

# Some tools are needed.
DPKG_TOOLS_DEPENDS="aptitude deborphan debian-keyring dpkg-dev gnupg"

# Latex packages
if [ "${LATEX_VER_NUM}" == "basic" ]; then
    LATEX_PKGS="texlive-fonts-recommended texlive-latex-base texlive-latex-extra \
        texlive-latex-recommended"
else
    LATEX_PKGS="texlive-full"
fi

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

# Latex: ghostscript fix
# ------------------------------------------------------------------------------
# There's a bug in Sid right now concerning ghostscript, this fixes it
# ref: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=970473

msginfo "Applying ghostscript fix ..."
{
    echo "deb ${MIRROR} buster main"
} | tee /etc/apt/sources.list.d/bugfix.list > /dev/null

cmdretry apt-get update

cmdretry apt-get install -d fonts-urw-base35 -t buster
cmdretry apt-get install fonts-urw-base35 -t buster

rm /etc/apt/sources.list.d/bugfix.list

# Apt: Install runtime dependencies
# ------------------------------------------------------------------------------
# Now we use some shell/apt plumbing to get runtime dependencies.

msginfo "Installing latex runtime dependencies ..."
DPKG_RUN_DEPENDS="$( aptitude search -F%p \
    $( printf '~RDepends:~n^%s$ ' ${LATEX_PKGS} ) | xargs printf ' %s ' | \
    sed "$( printf 's/\s%s\s/ /g;' ${LATEX_PKGS} )" )"
DPKG_DEPENDS="$( printf '%s\n' ${DPKG_RUN_DEPENDS} | uniq | xargs )"

cmdretry aptitude install -d ${DPKG_DEPENDS} python3-pygments
cmdretry aptitude install ${DPKG_DEPENDS} python3-pygments

# Latex: Installation
# ------------------------------------------------------------------------------
# We will install the packages listed in ${LATEX_PKGS}

msginfo "Installing Latex ..."
cmdretry apt-get install -d ${LATEX_PKGS}
cmdretry apt-get install ${LATEX_PKGS}

# Apt: Remove unnecessary packages
# ------------------------------------------------------------------------------
# We need to clear the filesystem of unwanted packages to shrink image size.

msginfo "Removing unnecessary packages ..."
# This is clever uh? I figured it out myself, ha!
cmdretry apt-get purge $( apt-mark showauto $( deborphan -a -n \
                            --no-show-section --guess-all --libdevel \
                            -p standard --add-keep "${LATEX_PKGS}" ) )
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