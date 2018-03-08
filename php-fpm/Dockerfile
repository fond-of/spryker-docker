FROM php:7.1-fpm

MAINTAINER Daniel Rose <daniel.rose@fondof.de>

ENV TERM xterm

RUN set -ex

# add backports
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

RUN apt-get update; \
    apt-get install -y \
        git \
        wget \
        postgresql-client \
        ssh \
        nano \
        vim \
        zsh \
        curl \
        libbz2-dev \
        libcurl4-gnutls-dev \
        libjpeg-dev \
        libpng12-dev \
        libgmp-dev \
        libicu-dev \
        libmcrypt-dev \
        libpq-dev \
        libxml2-dev

# oh my zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true;

# jre8
RUN apt-get install -yt jessie-backports openjdk-8-jre

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -; \
    apt-get install -y nodejs; \
    npm install --global yarn; \
    rm -rf /var/lib/apt/lists/*

# required list of php ext
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install bcmath bz2 curl gd gmp intl mbstring mcrypt opcache pdo pdo_pgsql pgsql xml zip

# redis
RUN pecl install redis-3.1.6; \
    docker-php-ext-enable redis

# composer
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O /tmp/installer; \
    php /tmp/installer --no-ansi --install-dir=/usr/bin --filename=composer --quiet; \
    rm /tmp/installer

RUN composer global require hirak/prestissimo

COPY php.ini /usr/local/etc/php/php.ini

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm"]