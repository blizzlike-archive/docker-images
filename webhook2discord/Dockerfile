FROM debian:stretch

MAINTAINER crito <crito@blizzlike.org>

ENV APP_DIR /home/app
ENV CONTRIB_DIR ./webhook2discord/rootfs
ENV LUA_MOD_DIR /usr/local/share/lua/5.1

RUN apt-get update && \
  apt-get -y install vim git \
    nginx libnginx-mod-http-lua \
    luarocks lua-filesystem lua-cjson

RUN luarocks install luna && \
  mkdir -p /etc/luna /var/lib/luna/endpoints

WORKDIR /tmp
RUN wget https://github.com/liseen/lua-resty-http/archive/master.tar.gz \
  -O resty-http.tar.gz && \
  tar xzf resty-http.tar.gz && \
  install -d ${LUA_MOD_DIR}/resty && \
  install lua-resty-http-master/lib/resty/*.lua ${LUA_MOD_DIR}/resty && \
  rm -r resty-http.tar.gz lua-resty-http-master

RUN useradd \
  -m -d ${APP_DIR} \
  -s /bin/bash \
  -U app

WORKDIR ${APP_DIR}
COPY ${CONTRIB_DIR}/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ${CONTRIB_DIR}/etc/nginx/conf.d/luna.conf /etc/nginx/conf.d/luna.conf
COPY ${CONTRIB_DIR}/etc/luna/rc.lua /etc/luna/rc.lua
COPY ${CONTRIB_DIR}/${APP_DIR}/run.sh ${APP_DIR}/run.sh

EXPOSE 80/tcp
VOLUME ['/var/lib/luna/endpoints']
