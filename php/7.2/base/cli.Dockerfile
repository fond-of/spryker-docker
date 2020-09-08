ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.2-fpm

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

USER root

COPY ./docker-entrypoint/base/cli.sh /usr/local/bin/docker-entrypoint.sh

USER www-data

CMD ["php"]
