FROM nginx:1.13.8

MAINTAINER Daniel Rose <daniel.rose@fondof.de>

ARG APPLICATION=yves

COPY ${APPLICATION}.template /etc/nginx/conf.d/default.template
COPY default.htpasswd /etc/nginx/conf.d/default.htpasswd

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]