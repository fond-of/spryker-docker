#!/bin/sh

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- mailcatcher "$@"
fi

exec "$@"
