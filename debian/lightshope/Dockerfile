FROM debian:stable

MAINTAINER crito <crito@fnordpipe.org>

RUN apt-get update && \
  apt-get -y install vim git \
    build-essential gcc g++ automake \
    autoconf make patch \
    libace-dev libmysql++-dev libtool \
    libssl-dev grep binutils zlibc \
    libc6 libbz2-dev cmake libboost-dev libboost-system-dev \
    libboost-program-options-dev libboost-thread-dev libboost-regex-dev \
    libtbb-dev
