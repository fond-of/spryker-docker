ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.2-fpm

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

RUN set -ex

RUN apt-get clean; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ruby \
        ruby-dev \
        build-essential \
        libsqlite3-dev

# mailcatcher client
RUN gem install mailcatcher

# xdebug
RUN pecl install xdebug; \
    docker-php-ext-enable xdebug

COPY ./ini/xdebug/php/opcache.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-opcache.ini
COPY ./ini/xdebug/php/xdebug.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-xdebug.ini

COPY ./docker-entrypoint/xdebug/fpm.sh /usr/local/bin/docker-entrypoint.sh