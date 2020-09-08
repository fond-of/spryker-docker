ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.2-fpm

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

USER root

RUN set -ex

RUN apt-get clean; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ruby \
        ruby-dev \
        build-essential \
        libsqlite3-dev \
        software-properties-common

# mailcatcher client
RUN gem install mailcatcher
COPY ./ini/dev/php/mailcatcher.ini /usr/local/etc/php/conf.d/docker-php-ext-mailcatcher.ini

# jre
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -; \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/; \
    apt-get update; \
    apt-get install -y --no-install-recommends adoptopenjdk-8-hotspot-jre

# opcache
COPY ./ini/dev/php/opcache.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-opcache.ini

# dev-ini
RUN mv /usr/local/etc/php/php.ini /usr/local/etc/php/php.ini.bkp; \
    mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# pm2
RUN npm install pm2 -g

COPY docker-entrypoint/dev/fpm.sh /usr/local/bin/docker-entrypoint.sh

USER www-data

# pm2 scripts and config
COPY ./pm2/* /var/www/pm2/
