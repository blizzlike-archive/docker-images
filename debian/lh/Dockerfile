FROM debian:stretch

MAINTAINER crito <crito@fnordpipe.org>

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
  -m -d /home/lightshope \
  -s /bin/bash \
  -U lightshope

USER lightshope

COPY ./debian/lightshope/home/lightshope/.bashrc /home/lightshope/.bashrc

WORKDIR /home/lightshope
RUN git clone https://github.com/lh-server/core.git
RUN mkdir /home/lightshope/build

WORKDIR /home/lightshope/build
#RUN cmake ../core -DUSE_ANTICHEAT=0 \
#    -DCMAKE_INSTALL_PREFIX=/home/lightshope/run
#    -DUSE_EXTRACTORS=1

USER root
