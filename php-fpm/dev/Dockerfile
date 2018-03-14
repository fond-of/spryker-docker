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

# use catchmail as sendmail path
RUN echo "sendmail_path = /usr/bin/env $(which catchmail) --smtp-ip $(getent hosts mailcatcher | awk '{ print $1 }') --smtp-port 1025 -f www-data@localhost" | tee /usr/local/etc/php/conf.d/docker-php-ext-mailcatcher.ini

COPY php.ini /usr/local/etc/php/php.ini