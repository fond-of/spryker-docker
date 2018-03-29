FROM registry.docker.fondofbags.com:5005/docker/spryker-php-fpm:7.1

MAINTAINER Daniel Rose <daniel.rose@fondof.de>

RUN set -ex

RUN apt-get update; \
    apt-get install -y \
        ruby \
        ruby-dev \
        build-essential \
        libsqlite3-dev

# mailcatcher client
RUN gem install mailcatcher

COPY php.ini /usr/local/etc/php/php.ini