ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.3-fpm

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

RUN set -ex

RUN apt-get clean; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ruby \
        ruby-dev \
        build-essential \
        libsqlite3-dev \
        python-pip \
        python-pkg-resources \
        software-properties-common

# mailcatcher client
RUN gem install mailcatcher

# jre
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/

RUN apt-get update; \
    apt-get install -y --no-install-recommends adoptopenjdk-8-hotspot-jre

# supervisor
RUN pip install supervisor; \
    mkdir -p /etc/supervisor/conf.d; \
    echo_supervisord_conf > /etc/supervisor/supervisord.conf; \
    echo "[include]" >> /etc/supervisor/supervisord.conf; \
    echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf;

COPY ./conf.d/base/supervisor/jenkins-slave.conf /etc/supervisor/conf.d/jenkins-slave.conf

COPY ./check-jenkins-jobs-count.sh /usr/local/bin/
COPY ./check-jenkins-node.sh /usr/local/bin/
COPY ./connect-to-jenkins-master.sh /usr/local/bin/

RUN mv /usr/local/etc/php/php.ini /usr/local/etc/php/php.ini.bkp; \
    mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

COPY ./ini/dev/php/opcache.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-opcache.ini

COPY docker-entrypoint/dev/fpm.sh /usr/local/bin/docker-entrypoint.sh