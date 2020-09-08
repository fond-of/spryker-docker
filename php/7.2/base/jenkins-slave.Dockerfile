ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.2-fpm

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

USER root

RUN set -ex

RUN apt-get clean; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        software-properties-common

# jre
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -; \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/; \
    apt-get update; \
    apt-get install -y --no-install-recommends adoptopenjdk-8-hotspot-jre

# pm2
RUN npm install pm2 -g

COPY ./docker-entrypoint/base/jenkins-slave.sh /usr/local/bin/docker-entrypoint.sh

USER www-data

# pm2 scripts and config
COPY ./pm2/* /var/www/pm2/

CMD ["/usr/bin/pm2", "start", "/var/www/pm2/ecosystem.config.yml"]
