FROM ubuntu:trusty

MAINTAINER crito <crito@fnordpipe.org>

ENV CORE_DIR /home/lh

RUN apt-get update && \
  apt-get -y install vim git software-properties-common \
    build-essential gcc g++ automake \
    autoconf make patch \
    libace-dev libmysql++-dev libtool \
    libssl-dev grep binutils zlibc \
    libc6 libbz2-dev cmake3 libboost-dev libboost-system-dev \
    libboost-program-options-dev libboost-thread-dev libboost-regex-dev \
    libtbb-dev libssl-dev libcurl4-openssl-dev

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
  apt-get update -qq && \
  apt-get install -qq g++-6 && \
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 90

RUN useradd \
  -m -d ${CORE_DIR} \
  -s /bin/bash \
  -U lh

USER lh

COPY ./rootfs/${CORE_DIR}/.bashrc ${CORE_DIR}/.bashrc

WORKDIR ${CORE_DIR}
RUN git clone https://github.com/lh-server/core.git
RUN mkdir ${CORE_DIR}/build

WORKDIR ${CORE_DIR}/build
USER root
