FROM ruby:2.4

MAINTAINER Daniel Rose <daniel.rose@fondofbags.com>

RUN set -ex; \
    gem install --no-ri --no-rdoc mailcatcher;

EXPOSE 1080 1025

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["-f", "--smtp-ip=0.0.0.0", "--http-ip=0.0.0.0"]
