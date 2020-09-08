#!/bin/sh
set -e

export NEW_RELIC_DAEMON_ADDRESS="$(ip route | awk 'NR==1{ print $3 }'):31339"

exec "$@"
