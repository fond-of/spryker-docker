FROM registry.docker.fondofbags.com:5005/docker/spryker-php-fpm:7.1

MAINTAINER Daniel Rose <daniel.rose@fondof.de>

RUN set -ex

# XDEBUG
RUN pecl install xdebug-2.6.0; \
    docker-php-ext-enable xdebug

RUN echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
     && echo "xdebug.max_nesting_level = 1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini