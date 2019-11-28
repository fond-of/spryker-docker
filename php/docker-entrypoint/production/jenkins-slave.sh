#!/bin/sh
set -e

export NEW_RELIC_DAEMON_ADDRESS="$(ip route | awk 'NR==1{ print $3 }'):31339"

IP=$(hostname -i)
IP_WITHOUT_DOTS=$(echo ${IP} | sed 's/\.//g')
export JENKINS_SLAVE_NAME="zed-worker-${IP_WITHOUT_DOTS}"

exec "$@"