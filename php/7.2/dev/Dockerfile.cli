ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.2-cli

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

RUN mv /usr/local/etc/php/php.ini /usr/local/etc/php/php.ini.bkp; \
    mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

COPY ./ini/dev/php/opcache.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-opcache.ini