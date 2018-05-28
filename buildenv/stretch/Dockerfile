FROM debian:stretch

MAINTAINER crito <crito@blizzlike.org>

ENV CORE_DIR /home/blizzlike
ENV CONTRIB_DIR ./buildenv/rootfs

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
    libtbb-dev libcurl4-openssl-dev libutfcpp-dev \
    python python-pip curl

RUN pip install awscli

RUN luarocks install mimetypes && \
  luarocks install octoflow

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get install -y nodejs && \
  npm install -g raml2html && \
  git clone https://github.com/blizzlike-org/raml2html-kaa-theme.git /usr/lib/node_modules/raml2html-kaa-theme

RUN useradd \
  -m -d ${CORE_DIR} \
  -s /bin/bash \
  -U blizzlike

USER blizzlike

COPY --chown=blizzlike ${CONTRIB_DIR}/${CORE_DIR}/.gitconfig ${CORE_DIR}/.gitconfig
COPY --chown=blizzlike ${CONTRIB_DIR}/${CORE_DIR}/travis ${CORE_DIR}/travis
RUN install -d ${CORE_DIR}/development \
  ${CORE_DIR}/build ${CORE_DIR}/core \
  ${CORE_DIR}/packages

WORKDIR ${CORE_DIR}

VOLUME ["${CORE_DIR}/development", "${CORE_DIR}/packages"]
