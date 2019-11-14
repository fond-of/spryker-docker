#!/bin/sh
set -e

PATH_TO_SPRYKER="/var/www/spryker/releases/current/"

set +e

which catchmail
if [ $? -eq  0 ]; then
    echo "sendmail_path = /usr/bin/env $(which catchmail) --smtp-ip $(getent hosts mailcatcher | awk '{ print $1 }') --smtp-port 1025 -f www-data@localhost" | tee /usr/local/etc/php/conf.d/docker-php-ext-mailcatcher.ini
fi

set -e

if [ -d "${PATH_TO_SPRYKER}public" ] && [ ! -L "/var/www/html" ]; then
    rm -Rf /var/www/html
    ln -s ${PATH_TO_SPRYKER}public /var/www/html
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php "$@"
fi

exec "$@"