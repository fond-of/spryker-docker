ARG NGINX_VERSION=1.16.1

FROM nginx:$NGINX_VERSION

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

ARG APPLICATION=yves

COPY ${APPLICATION}.template /etc/nginx/conf.d/default.template
COPY logformat.conf /etc/nginx/conf.d/logformat.conf
COPY upstream.conf /etc/nginx/conf.d/upstream.conf

RUN rm /var/log/nginx/access.log \
    && ln -sf /dev/stdout /var/log/nginx/apm_access.log

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]