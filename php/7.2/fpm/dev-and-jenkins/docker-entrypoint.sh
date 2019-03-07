#!/bin/sh
set -e

IP=$(hostname -i)
IP_WITHOUT_DOTS=$(echo ${IP} | sed 's/\.//g')
export JENKINS_SLAVE_NAME="zed-worker-${IP_WITHOUT_DOTS}"

exec "$@"