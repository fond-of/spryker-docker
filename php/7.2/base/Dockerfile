FROM php:7.2-fpm-buster

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

ENV TERM xterm

RUN set -ex

RUN echo 'Acquire::http::Pipeline-Depth "0";' > /etc/apt/apt.conf.d/99fixbadproxy; \
    echo 'Acquire::http::No-Cache=True;' >> /etc/apt/apt.conf.d/99fixbadproxy; \
    echo 'Acquire::BrokenProxy=true;' >> /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get clean; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git \
        wget \
        gnupg2 \
        graphviz \
        ssh \
        nano \
        vim \
        zsh \
        curl \
        libbz2-dev \
        libcurl4-gnutls-dev \
        libjpeg-dev \
        libpng-dev \
        libgmp-dev \
        libicu-dev \
        libmcrypt-dev \
        libxml2-dev \
        libzip-dev \
        locales \
        openssl

ENV OPENSSL_CONF /etc/ssl/

# locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen; \
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen; \
    locale-gen

# postgresql-client
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        postgresql-client-9.6 \
        libpq5 \
        libpq-dev

# oh my zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true;

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -; \
    apt-get install -y --no-install-recommends nodejs; \
    npm install --global yarn; \
    rm -rf /var/lib/apt/lists/*

# required list of php ext
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install bcmath bz2 curl gd gmp intl mbstring opcache pdo pdo_pgsql pgsql sockets xml zip

# mcrypt
RUN pecl install mcrypt; \
    docker-php-ext-enable mcrypt

# redis
RUN pecl install redis; \
    docker-php-ext-enable redis

# composer
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/master/web/installer -O /tmp/installer; \
    php /tmp/installer --no-ansi --install-dir=/usr/bin --filename=composer --quiet; \
    rm /tmp/installer

ENV COMPOSER_MEMORY_LIMIT -1

RUN composer global require hirak/prestissimo; \
    composer self-update

RUN mv /usr/local/etc/php/php.ini /usr/local/etc/php/php.ini.bkp; \
    mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

COPY ./ini/base/php/general.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-general.ini
COPY ./ini/base/php/opcache.ini /usr/local/etc/php/conf.d/zzz-docker-php-ext-opcache.ini
COPY ./conf.d/base/fpm/log-docker.conf /usr/local/etc/php-fpm.d/log-docker.conf

RUN chown www-data:www-data /var/www/ -R;

COPY ./docker-entrypoint/base/fpm.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm"]