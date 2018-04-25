#!/bin/sh
set -e

PATH_TO_SPRYKER="/var/www/spryker/releases/current/"

PATH_TO_JENKINS_CLI="/usr/local/bin/jenkins-cli.jar"
PATH_TO_JENKINS_SLAVE="/usr/local/bin/jenkins-slave.jar"

JENKINS_URL="${JENKINS_URL:-http://jenkins:8080}"
JENKINS_SLAVE_NAME="zed-worker"

SUPERVISOR_CONF=$(cat <<EOF
[program:akeneo_queue_daemon]
command=/usr/bin/java -jar ${PATH_TO_JENKINS_SLAVE} -jnlpUrl ${JENKINS_URL}/computer/${JENKINS_SLAVE_NAME}/slave-agent.jnlp
autostart=true
autorestart=true
stderr_logfile=/var/log/jenkins_slave.err.log
stdout_logfile=/var/log/jenkins_slave.out.log
user=www-data
environment=POSTGRES_USER="%(ENV_POSTGRES_USER)s",POSTGRES_PASSWORD="%(ENV_POSTGRES_PASSWORD)s",PGPASSWORD="%(ENV_PGPASSWORD)s",RABBITMQ_DEFAULT_USER="%(ENV_RABBITMQ_DEFAULT_USER)s",RABBITMQ_DEFAULT_PASS="%(ENV_RABBITMQ_DEFAULT_PASS)s",ELASTICSEARCH_HOST="%(ENV_ELASTICSEARCH_HOST)s",ELASTICSEARCH_PORT="%(ENV_ELASTICSEARCH_PORT)s",JENKINS_URL="%(ENV_JENKINS_URL)s",REDIS_HOST="%(ENV_REDIS_HOST)s",REDIS_PORT="%(ENV_REDIS_PORT)s",POSTGRES_HOST="%(ENV_POSTGRES_HOST)s",POSTGRES_PORT="%(ENV_POSTGRES_PORT)s",RABBITMQ_HOST="%(ENV_RABBITMQ_HOST)s",RABBITMQ_PORT="%(ENV_RABBITMQ_PORT)s",RABBITMQ_API_HOST="%(ENV_RABBITMQ_API_HOST)s",RABBITMQ_API_PORT="%(ENV_RABBITMQ_API_PORT)s",APPLICATION_ENV="%(ENV_APPLICATION_ENV)s",APPLICATION_STORE="%(ENV_APPLICATION_STORE)s"
EOF
)

set +e

which catchmail
if [ $? == 0 ]; then
    echo "sendmail_path = /usr/bin/env $(which catchmail) --smtp-ip $(getent hosts mailcatcher | awk '{ print $1 }') --smtp-port 1025 -f www-data@localhost" | tee /usr/local/etc/php/conf.d/docker-php-ext-mailcatcher.ini
fi

set -e

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

echo "${SUPERVISOR_CONF}" > /etc/supervisor/conf.d/jenkins-slave.conf
/usr/local/bin/supervisord -c /etc/supervisor/supervisord.conf

if [ -d "${PATH_TO_SPRYKER}public" ] && [ ! -L "/var/www/html" ]; then
    rm -Rf /var/www/html
    ln -s ${PATH_TO_SPRYKER}public /var/www/html
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"