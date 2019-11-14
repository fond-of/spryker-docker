ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.2-fpm

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

RUN set -ex

RUN apt-get clean; \
    apt-get update; \
    apt-get install -y \
        ruby \
        ruby-dev \
        build-essential \
        libsqlite3-dev \
        python-pip \
        software-properties-common

# mailcatcher client
RUN gem install mailcatcher

# jre
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/

RUN apt-get update; \
    apt-get install -y adoptopenjdk-8-hotspot-jre

# supervisor
RUN pip install supervisor; \
    mkdir -p /etc/supervisor/conf.d; \
    echo_supervisord_conf > /etc/supervisor/supervisord.conf; \
    echo "[include]" >> /etc/supervisor/supervisord.conf; \
    echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf;

COPY ./conf.d/base/supervisor/jenkins-slave.conf /etc/supervisor/conf.d/jenkins-slave.conf

RUN mv /usr/local/etc/php/php.ini /usr/local/etc/php/php.ini.bkp; \
    mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

COPY ./ini/dev/php/opcache.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-opcache.ini

COPY docker-entrypoint/dev/fpm.sh /usr/local/bin/docker-entrypoint.sh