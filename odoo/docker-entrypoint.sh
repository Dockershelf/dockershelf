#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${1:0:1}" = '-' ]; then
    set -- odoo "${@}"
fi

originalArgOne="${1}"

# allow the container to be started with `--user`
# all mongo* commands should be dropped to the correct user
if [[ "$originalArgOne" == odoo* ]] && [ "$(id -u)" = '0' ]; then
    if [ "$originalArgOne" = 'odoo' ]; then
        chown -R odoo /var/lib/odoo /mnt/extra-addons
    fi

    # make sure we can write to stdout and stderr as "odoo"
    # (for our "initdb" code later; see "--logpath" below)
    chown --dereference odoo "/proc/$$/fd/1" "/proc/$$/fd/2" || :
    # ignore errors thanks to https://github.com/docker-library/mongo/issues/149

    sudo -H -u odoo bash -c "\"${BASH_SOURCE}\" \"${@}\""
fi

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file
: ${HOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${PORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}}
: ${ODOO_RC:='/etc/odoo/odoo.conf'}

DB_ARGS=()

function check_config() {
    param="${1}"
    value="${2}"
    if ! grep -q -E "^\s*\b${param}\b\s*=" "${ODOO_RC}" ; then
        DB_ARGS+=("--${param}")
        DB_ARGS+=("${value}")
   fi;
}

check_config "db_host" "${HOST}"
check_config "db_port" "${PORT}"
check_config "db_user" "${USER}"
check_config "db_password" "${PASSWORD}"
check_config "config" "${ODOO_RC}"

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec odoo "${@}"
        else
            exec odoo "${@}" "${DB_ARGS[@]}"
        fi
        ;;
    -*)
        exec odoo "${@}" "${DB_ARGS[@]}"
        ;;
    *)
        exec "${@}"
esac

exit 1
