FROM nginx:1.16

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

ARG APPLICATION=yves

COPY ./conf.d/base/$APPLICATION.template /etc/nginx/conf.d/default.template
COPY ./conf.d/base/default.htpasswd /etc/nginx/conf.d/default.htpasswd
COPY ./conf.d/base/logformat.conf /etc/nginx/conf.d/logformat.conf
COPY ./conf.d/base/upstream.conf /etc/nginx/conf.d/upstream.conf

RUN rm /var/log/nginx/access.log \
    && ln -sf /dev/stdout /var/log/nginx/apm_access.log

COPY ./docker-entrypoint/base/nginx.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]