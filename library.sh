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

ANSI_RED="\033[31;1m"
ANSI_GREEN="\033[32;1m"
ANSI_YELLOW="\033[33;1m"
ANSI_RESET="\033[0m"
ANSI_CLEAR="\033[0K"

msginfo(){
    echo -e "\n${ANSI_YELLOW}${1}${ANSI_RESET}\n"
}

msgsuccess(){
    echo -e "\n${ANSI_GREEN}${1}${ANSI_RESET}\n"
}

msgerror(){
    echo -e "\n${ANSI_RED}${1}${ANSI_RESET}\n" >&2
}

cmdretry() {
    local RESULT=0
    local COUNT=1

    while [ ${COUNT} -le 3 ]; do
        if [ ${RESULT} -ne 0 ]; then
            msgerror "The command \"${@}\" failed. Retrying, ${COUNT} of 3."
        fi

        set +e
        "${@}"
        RESULT=${?}
        set -e

        if [ ${RESULT} -eq 0 ]; then
            break
        fi

        COUNT=$((${COUNT} + 1))
    done

    if [ ${COUNT} -gt 3 ]; then
        msgerror "The command \"${@}\" failed 3 times."
    fi

    return ${RESULT}
}