#!/bin/sh
set -e

export NEW_RELIC_DAEMON_ADDRESS=$(ip route | awk 'NR==1{ print $3 }'):31339

PATH_TO_SPRYKER="/var/www/spryker/releases/current/"

if [ -d "${PATH_TO_SPRYKER}public" ] && [ ! -L "/var/www/html" ]; then
    rm -Rf /var/www/html
    ln -s ${PATH_TO_SPRYKER}public /var/www/html
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php "$@"
fi

exec "$@"