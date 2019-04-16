FROM php-fpm:7.2-cli-stretch

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php"]