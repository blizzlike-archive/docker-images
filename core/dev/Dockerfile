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
    libtbb-dev libssl-dev libcurl4-openssl-dev

RUN useradd \
  -m -d ${CORE_DIR} \
  -s /bin/bash \
  -U core

USER core

COPY ./rootfs/${CORE_DIR}/.bashrc ${CORE_DIR}/.bashrc

WORKDIR ${CORE_DIR}
RUN mkdir ${CORE_DIR}/development ${CORE_DIR}/build

USER root

VOLUME ["${CORE_DIR}/development"]
