#!/bin/sh
set -e

PATH_TO_SPRYKER="/var/www/spryker/releases/current/"
PATH_TO_SHARED_FILES="/var/www/spryker/shared/"

if [ -d "${PATH_TO_SPRYKER}public" ] && [ ! -L "/var/www/html" ]; then
    rm -Rf /var/www/html
    ln -s ${PATH_TO_SPRYKER}public /var/www/html
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"