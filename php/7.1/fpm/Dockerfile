FROM php:7.1-fpm-buster

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

ENV TERM xterm

RUN set -ex

RUN echo 'Acquire::http::Pipeline-Depth "0";' > /etc/apt/apt.conf.d/99fixbadproxy; \
    echo 'Acquire::http::No-Cache=True;' >> /etc/apt/apt.conf.d/99fixbadproxy; \
    echo 'Acquire::BrokenProxy=true;' >> /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get update; \
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
        locales \
        openssl \
        software-properties-common

ENV OPENSSL_CONF /etc/ssl/

# locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen; \
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen; \
    locale-gen

# postgresql-client
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update; \
    apt-get install -y \
        postgresql-client-9.6 \
        libpq5 \
        libpq-dev

# oh my zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true;

# jre
# RUN apt-get install -y openjdk-11-jre
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/

RUN apt-get update; \
    apt-get install -y adoptopenjdk-8-hotspot-jre

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -; \
    apt-get install -y nodejs; \
    npm install --global yarn; \
    rm -rf /var/lib/apt/lists/*

# required list of php ext
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install bcmath bz2 curl gd gmp intl mbstring mcrypt opcache pdo pdo_pgsql pgsql sockets xml zip

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

COPY php.ini /usr/local/etc/php/php.ini
COPY log-docker.conf /usr/local/etc/php-fpm.d/log-docker.conf

RUN pip install supervisor; \
    mkdir -p /etc/supervisor/conf.d; \
    echo_supervisord_conf > /etc/supervisor/supervisord.conf; \
    echo "[include]" >> /etc/supervisor/supervisord.conf; \
    echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf;

# jenkins
RUN mkdir -p /data; \
    chown www-data:www-data /data -R; \
    chown www-data:www-data /var/www/ -R;

COPY check-jenkins-jobs-count.sh /usr/local/bin/
COPY check-jenkins-node.sh /usr/local/bin/
COPY connect-to-jenkins-master.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm"]