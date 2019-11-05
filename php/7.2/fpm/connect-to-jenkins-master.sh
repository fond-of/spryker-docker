#!/bin/sh
set -e

PATH_TO_JENKINS_CLI="/usr/local/bin/jenkins-cli.jar"
PATH_TO_JENKINS_SLAVE="/usr/local/bin/jenkins-slave.jar"

waitForHttpService() {
  url=$1; shift
  until curl -s -k ${url} -o /dev/null -L --fail $*; do
    sleep 1
  done
}

waitForHttpService ${JENKINS_URL}

if [ ! -f "${PATH_TO_JENKINS_CLI}" ]; then
    curl -s ${JENKINS_URL}/jnlpJars/jenkins-cli.jar -o ${PATH_TO_JENKINS_CLI}
fi

if [ ! -f "${PATH_TO_JENKINS_SLAVE}" ]; then
    curl -s ${JENKINS_URL}/jnlpJars/slave.jar -o ${PATH_TO_JENKINS_SLAVE}
fi

supervisorctl start check_jenkins_node
supervisorctl start check_jenkins_jobs_count
supervisorctl start jenkins_slave
