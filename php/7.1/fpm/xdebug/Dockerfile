ARG FROM_REGISTRY
ARG FROM_IMAGE_NAME

FROM $FROM_REGISTRY/$FROM_IMAGE_NAME:7.1-dev

MAINTAINER Daniel Rose <daniel.rose@fondof.de>

RUN set -ex

# XDEBUG
RUN pecl install xdebug-2.6.0; \
    docker-php-ext-enable xdebug

COPY php.ini /usr/local/etc/php/php.ini