#!/bin/sh
set -e

export ESC="$"

envsubst < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf

exec "$@"