FROM php:7.2-fpm-stretch

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

ENV TERM xterm

RUN set -ex

RUN echo 'Acquire::http::Pipeline-Depth "0";' > /etc/apt/apt.conf.d/99fixbadproxy; \
    echo 'Acquire::http::No-Cache=True;' >> /etc/apt/apt.conf.d/99fixbadproxy; \
    echo 'Acquire::BrokenProxy=true;' >> /etc/apt/apt.conf.d/99fixbadproxy


RUN apt-get clean; \
    apt-get update; \
    apt-get install -y \
        git \
        wget \
        gnupg2 \
        graphviz \
        python-pip \
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
        locales

# locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen; \
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen; \
    locale-gen

# postgresql-client
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update; \
    apt-get install -y \
        postgresql-client-9.6 \
        libpq5 \
        libpq-dev

# oh my zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true;

# jre8
RUN apt-get install -y openjdk-8-jre

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -; \
    apt-get install -y nodejs; \
    npm install --global yarn; \
    rm -rf /var/lib/apt/lists/*

# required list of php ext
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install bcmath bz2 curl gd gmp intl mbstring opcache pdo pdo_pgsql pgsql sockets xml zip

# redis
RUN pecl install mcrypt-1.0.2; \
    docker-php-ext-enable mcrypt

# redis
RUN pecl install redis-4.2.0; \
    docker-php-ext-enable redis

# composer
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/master/web/installer -O /tmp/installer; \
    php /tmp/installer --no-ansi --install-dir=/usr/bin --filename=composer --quiet; \
    rm /tmp/installer

RUN composer global require hirak/prestissimo
RUN composer self-update

COPY php.ini /usr/local/etc/php/php.ini

# supervisor
RUN easy_install supervisor; \
    mkdir -p /etc/supervisor/conf.d; \
    echo_supervisord_conf > /etc/supervisor/supervisord.conf; \
    echo "[include]" >> /etc/supervisor/supervisord.conf; \
    echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf;

# jenkins
RUN mkdir -p /data; \
    chown www-data:www-data /data -R; \
    chown www-data:www-data /var/www/ -R;

COPY check-jenkins-jobs-count.sh /usr/local/bin/
COPY connect-to-jenkins-master.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm"]