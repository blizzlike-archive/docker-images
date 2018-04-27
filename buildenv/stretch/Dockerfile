FROM debian:stretch

MAINTAINER crito <crito@blizzlike.org>

ENV CORE_DIR /home/core

RUN apt-get update && \
  apt-get -y install vim git \
    build-essential gcc g++ automake \
    autoconf make patch \
    libace-dev libmysql++-dev libtool \
    libssl-dev grep binutils zlibc \
    libc6 libbz2-dev cmake libboost-dev libboost-system-dev \
    libboost-program-options-dev libboost-thread-dev libboost-regex-dev \
    libtbb-dev libcurl4-openssl-dev libutfcpp-dev

RUN useradd \
  -m -d ${CORE_DIR} \
  -s /bin/bash \
  -U core

USER core

COPY --chown=core ./buildenv/stretch/rootfs/${CORE_DIR}/build.sh ${CORE_DIR}/build.sh
RUN mkdir ${CORE_DIR}/development \
  ${CORE_DIR}/build ${CORE_DIR}/core \
  ${CORE_DIR}/release

WORKDIR ${CORE_DIR}/build

VOLUME ["${CORE_DIR}/development", "${CORE_DIR}/release"]
