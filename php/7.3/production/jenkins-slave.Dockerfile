ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.3-jenkins-slave

ARG NEW_RELIC_AGENT_VERSION=9.3.0.248

RUN apt-get clean; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  iproute2

RUN curl -L "https://download.newrelic.com/php_agent/archive/${NEW_RELIC_AGENT_VERSION}/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux.tar.gz" | tar -C /tmp -zx \
  && export NR_INSTALL_USE_CP_NOT_LN=1 \
  && export NR_INSTALL_SILENT=1 \
  && /tmp/newrelic-php5-*/newrelic-install install \
  && rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*

RUN sed -i -e 's/\"REPLACE_WITH_REAL_KEY\"/\${NEW_RELIC_LICENSE_KEY}/' \
  -e 's/newrelic.appname\s=\s.*/newrelic.appname=\${NEW_RELIC_APPNAME}/' \
  -e 's/\;newrelic.daemon.address\s=\s.*/newrelic.daemon.address=\${NEW_RELIC_DAEMON_ADDRESS}/' \
  -e 's/\;newrelic.daemon.dont_launch\s=\s.*/newrelic.daemon.dont_launch=3'/ \
  /usr/local/etc/php/conf.d/newrelic.ini

COPY ./docker-entrypoint/production/jenkins-slave.sh /usr/local/bin/docker-entrypoint.sh