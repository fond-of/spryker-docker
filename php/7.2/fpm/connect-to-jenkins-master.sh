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

(/usr/bin/java -jar ${PATH_TO_JENKINS_CLI} -s ${JENKINS_URL} get-node ${JENKINS_SLAVE_NAME} 2>&1 || true ) > /tmp/jenkins.node
if grep ERROR: /tmp/jenkins.node >/dev/null; then
    cat <<EOF | /usr/bin/java -jar ${PATH_TO_JENKINS_CLI} -s ${JENKINS_URL} create-node ${JENKINS_SLAVE_NAME}
        <slave>
            <name>backend</name>
            <description></description>
            <remoteFS>/data/shop</remoteFS>
            <numExecutors>3</numExecutors>
            <mode>NORMAL</mode>
            <retentionStrategy class="hudson.slaves.RetentionStrategy$Always"/>
            <launcher class="hudson.slaves.JNLPLauncher"/>
            <label>backend</label>
            <nodeProperties/>
        </slave>
EOF
fi

/usr/bin/java -jar ${PATH_TO_JENKINS_CLI} -s ${JENKINS_URL} offline-node ""
supervisorctl start check_jenkins_jobs_count
supervisorctl start jenkins_slave
