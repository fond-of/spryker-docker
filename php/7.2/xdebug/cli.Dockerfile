ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.2-cli

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

USER root

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
COPY ./ini/dev/php/mailcatcher.ini /usr/local/etc/php/conf.d/docker-php-ext-mailcatcher.ini

# xdebug
RUN pecl install xdebug; \
    docker-php-ext-enable xdebug
COPY ./ini/xdebug/php/xdebug.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-xdebug.ini

# opcache
COPY ./ini/xdebug/php/opcache.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-opcache.ini

# dev-ini
RUN mv /usr/local/etc/php/php.ini /usr/local/etc/php/php.ini.bkp; \
    mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

USER www-data

