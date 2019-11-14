ARG APPLICATION=yves
ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:1.16-$APPLICATION

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

ARG APPLICATION

COPY ./conf.d/xdebug/$APPLICATION.template /etc/nginx/conf.d/default.template
COPY ./conf.d/xdebug/upstream.conf /etc/nginx/conf.d/upstream.conf
