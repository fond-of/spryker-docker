FROM 493499581187.dkr.ecr.eu-central-1.amazonaws.com/fond-of-spryker/php-fpm:7.1-dev

MAINTAINER Daniel Rose <daniel.rose@fondof.de>

RUN set -ex

# XDEBUG
RUN pecl install xdebug-2.6.0; \
    docker-php-ext-enable xdebug

COPY php.ini /usr/local/etc/php/php.ini