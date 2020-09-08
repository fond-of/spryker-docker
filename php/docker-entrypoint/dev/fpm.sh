#!/bin/sh
set +e

which catchmail
if [ $? -eq  0 ]; then
    export PATH_TO_CATCHMAIL=$(which catchmail)
    export MAILCATCHER_IP=$(getent hosts mailcatcher | awk '{ print $1 }')
fi

set -e

pm2 start /var/www/pm2/ecosystem.config.yml

PATH_TO_SPRYKER="/var/www/spryker/releases/current/"

if [ -d "${PATH_TO_SPRYKER}public" ] && [ ! -L "/var/www/html" ]; then
    rm -Rf /var/www/html
    ln -s ${PATH_TO_SPRYKER}public /var/www/html
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"
