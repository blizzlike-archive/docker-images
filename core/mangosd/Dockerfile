FROM debian:stretch

MAINTAINER crito <crito@blizzlike.org>

ENV APP_DIR /var/lib/core

RUN apt-get update && \
  apt-get install -y libace-6.3.3 \
    libmariadbclient18 libtbb2 libcurl3 \
    wget xz-utils

RUN useradd \
  -m -d ${APP_DIR} \
  -s /bin/bash \
  -U core

RUN wget https://github.com/blizzlike-org/core/releases/download/latest/core-stretch.tar.xz \
    -O /tmp/core-stretch.tar.xz && \
  tar xJf /tmp/core-stretch.tar.xz -C /opt && \
  rm /tmp/core-stretch.tar.xz

USER core
WORKDIR /opt/core
COPY ./core/mangosd/rootfs/opt/core/etc/mangosd.conf /opt/core/etc/mangosd.conf

VOLUME ["/opt/core/etc", "${APP_DIR}/data"]
EXPOSE 8085

CMD ["/opt/core/bin/mangosd -c /opt/core/etc/mangosd.conf"]
