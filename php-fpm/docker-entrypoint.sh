#!/bin/sh
set -e

PATH_TO_SPRYKER="/var/www/spryker/releases/current/"

PATH_TO_JENKINS_CLI="/usr/local/bin/jenkins-cli.jar"
PATH_TO_JENKINS_SLAVE="/usr/local/bin/jenkins-slave.jar"

JENKINS_URL="http://jenkins:8080"
JENKINS_SLAVE_NAME="zed-worker"

waitForHttpService() {
  url=$1; shift
  until curl -s -k  ${url} -o /dev/null -L --fail $*; do
    sleep 1
  done
}

waitForHttpService $JENKINS_URL

if [ ! -f "${PATH_TO_JENKINS_CLI}" ]; then
    curl -s $JENKINS_URL/jnlpJars/jenkins-cli.jar -o ${PATH_TO_JENKINS_CLI}
fi

if [ ! -f "${PATH_TO_JENKINS_SLAVE}" ]; then
    curl -s $JENKINS_URL/jnlpJars/slave.jar -o ${PATH_TO_JENKINS_SLAVE}
fi

(java -jar ${PATH_TO_JENKINS_CLI} -s ${JENKINS_URL} get-node ${JENKINS_SLAVE_NAME} 2>&1 || true ) > /tmp/jenkins.node
if grep ERROR: /tmp/jenkins.node >/dev/null; then
    cat <<EOF | java -jar ${PATH_TO_JENKINS_CLI} -s ${JENKINS_URL} create-node ${JENKINS_SLAVE_NAME}
        <slave>
            <name>backend</name>
            <description></description>
            <remoteFS>/data/shop</remoteFS>
            <numExecutors>1</numExecutors>
            <mode>NORMAL</mode>
            <retentionStrategy class="hudson.slaves.RetentionStrategy$Always"/>
            <launcher class="hudson.slaves.JNLPLauncher"/>
            <label>backend</label>
            <nodeProperties/>
        </slave>
EOF
fi

java -jar ${PATH_TO_JENKINS_CLI} -s ${JENKINS_URL} offline-node ""
java -jar ${PATH_TO_JENKINS_SLAVE} -jnlpUrl ${JENKINS_URL}/computer/${JENKINS_SLAVE_NAME}/slave-agent.jnlp &

if [ -d "${PATH_TO_SPRYKER}public" ] && [ ! -L "/var/www/html" ]; then
    rm -Rf /var/www/html
    ln -s ${PATH_TO_SPRYKER}public /var/www/html
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"