#!/bin/sh
set -e

PATH_TO_JENKINS_CLI="/usr/local/bin/jenkins-cli.jar"

if [ ! -f "${PATH_TO_JENKINS_CLI}" ]; then
    exit 1
fi

JOBS_COUNT=$(/usr/bin/java -jar ${PATH_TO_JENKINS_CLI} -s ${JENKINS_URL} list-jobs | wc -l)

echo "$(date '+%Y-%m-%d %H:%M:%S') Starting..."

while true
do
    echo "$(date '+%Y-%m-%d %H:%M:%S') Checking jobs count..."

        if [ ${JOBS_COUNT} -eq 0 ] && [ ! -z ${RECIPE_NAME} ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Creating jobs..."

        cd /var/www/spryker/releases/current
        vendor/bin/install -r ${RECIPE_NAME} -s jenkins-generate > /dev/null 2>&1
    fi

    sleep 60
done

echo "$(date '+%Y-%m-%d %H:%M:%S') Stopping..."

exit 1