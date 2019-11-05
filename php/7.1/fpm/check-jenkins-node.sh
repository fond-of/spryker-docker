#!/bin/sh
set -e

PATH_TO_JENKINS_CLI="/usr/local/bin/jenkins-cli.jar"

if [ ! -f "${PATH_TO_JENKINS_CLI}" ]; then
    exit 1
fi

while true
do
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
    sleep 60
done
