ARG REGISTRY
ARG IMAGE_NAME

FROM $REGISTRY/$IMAGE_NAME:7.3-fpm

MAINTAINER Daniel Rose <daniel-rose@gmx.de>

RUN set -ex

RUN apt-get clean; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python-pip \
        python-pkg-resources \
        software-properties-common

# jre
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/

RUN apt-get update; \
    apt-get install -y --no-install-recommends adoptopenjdk-8-hotspot-jre

# supervisor
RUN pip install supervisor; \
    mkdir -p /etc/supervisor/conf.d; \
    echo_supervisord_conf > /etc/supervisor/supervisord.conf; \
    echo "[include]" >> /etc/supervisor/supervisord.conf; \
    echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf;

COPY ./conf.d/base/supervisor/jenkins-slave.conf /etc/supervisor/conf.d/jenkins-slave.conf

COPY ./check-jenkins-jobs-count.sh /usr/local/bin/
COPY ./check-jenkins-node.sh /usr/local/bin/
COPY ./connect-to-jenkins-master.sh /usr/local/bin/

COPY ./docker-entrypoint/base/jenkins-slave.sh /usr/local/bin/docker-entrypoint.sh

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]