#!/usr/bin/env bash

ANSI_RED="\033[31;1m"
ANSI_GREEN="\033[32;1m"
ANSI_YELLOW="\033[33;1m"
ANSI_RESET="\033[0m"
ANSI_CLEAR="\033[0K"

msginfo(){
    echo -e "\n${ANSI_YELLOW}${1}${ANSI_RESET}\n\n"
}

msgsuccess(){
    echo -e "\n${ANSI_GREEN}${1}${ANSI_RESET}\n\n"
}

msgerror(){
    echo -e "\n${ANSI_RED}${1}${ANSI_RESET}\n\n" >&2
}

cmdretry() {
    set +ex
    local RESULT=0
    local COUNT=1

    while [ ${COUNT} -le 3 ]; do
        if [ ${RESULT} -ne 0 ]; then
            msgerror "The command \"$@\" failed. Retrying, ${COUNT} of 3."
        fi

        "$@"
        RESULT=$?

        if [ ${RESULT} -eq 0 ]; then
            break
        fi

        COUNT=$((${COUNT} + 1))
        sleep 1
    done

    if [ ${COUNT} -gt 3 ]; then
        msgerror "The command \"$@\" failed 3 times."
    fi

    set -ex
    return ${RESULT}
}