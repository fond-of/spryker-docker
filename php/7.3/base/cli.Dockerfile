ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.3-fpm

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

COPY ./docker-entrypoint/base/cli.sh /usr/local/bin/docker-entrypoint.sh

CMD ["php"]