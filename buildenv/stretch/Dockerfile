FROM debian:stretch

MAINTAINER crito <crito@blizzlike.org>

ENV CORE_DIR /home/blizzlike
ENV CONTRIB_DIR ./buildenv/stretch/rootfs

RUN apt-get update && \
  apt-get -y install vim git \
    lua5.1 lua-cjson lua-socket lua-sec \
    lua-filesystem luarocks \
    build-essential gcc g++ automake \
    autoconf make patch \
    libace-dev libmysql++-dev libtool \
    libssl-dev grep binutils zlibc \
    libc6 libbz2-dev cmake libboost-dev libboost-system-dev \
    libboost-program-options-dev libboost-thread-dev libboost-regex-dev \
    libtbb-dev libcurl4-openssl-dev libutfcpp-dev

RUN luarocks install mimetypes && \
  install -d 0755 /tmp/octoflow && \
  wget -O /tmp/octoflow.tar.gz \
    https://github.com/blizzlike-org/octoflow/archive/master.tar.gz && \
  tar xzf /tmp/octoflow.tar.gz -C /tmp/octoflow && \
  cp -r /tmp/octoflow/octoflow-master/src/* /usr/share/lua/5.1/ && \
  rm -rf /tmp/octoflow.tar.gz /tmp/octoflow

RUN useradd \
  -m -d ${CORE_DIR} \
  -s /bin/bash \
  -U blizzlike

USER blizzlike

COPY --chown=blizzlike ${CONTRIB_DIR}/home/blizzlike/travis ${CORE_DIR}/travis
RUN install -d ${CORE_DIR}/development \
  ${CORE_DIR}/build ${CORE_DIR}/core \
  ${CORE_DIR}/packages

WORKDIR ${CORE_DIR}

VOLUME ["${CORE_DIR}/development", "${CORE_DIR}/packages"]
