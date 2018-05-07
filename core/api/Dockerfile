FROM debian:stretch

MAINTAINER crito <crito@blizzlike.org>

ENV APP_DIR /home/app
ENV CONTRIB_DIR ./core/api/rootfs
ENV LUA_MOD_DIR /usr/local/share/lua/5.1

RUN apt-get update && \
  apt-get -y install vim git \
    nginx libnginx-mod-http-lua \
    luarocks lua-cjson lua-sql-mysql

RUN luarocks install luna && \
  luarocks install lbase64 && \
  mkdir -p /etc/luna /var/lib/luna/endpoints

WORKDIR /tmp
RUN wget https://github.com/duhoobo/lua-resty-smtp/archive/master.tar.gz \
    -O resty-smtp.tar.gz && \
  tar xzf resty-smtp.tar.gz && \
  install -d ${LUA_MOD_DIR}/resty && \
  install -d ${LUA_MOD_DIR}/resty/smtp && \
  install lua-resty-smtp-master/lib/resty/*.lua ${LUA_MOD_DIR}/resty && \
  install lua-resty-smtp-master/lib/resty/smtp/*.lua ${LUA_MOD_DIR}/resty/smtp && \
  rm -r resty-smtp.tar.gz lua-resty-smtp-master

RUN wget https://github.com/blizzlike-org/core-api/archive/master.tar.gz \
    -O api.tar.gz && \
  tar xzf api.tar.gz && \
  mv ./core-api-master/src/endpoints /var/lib/luna/endpoints/v1 && \
  mv ./core-api-master/src/modules /var/lib/luna/modules && \
  rm -r api.tar.gz core-api-master

RUN useradd \
  -m -d ${APP_DIR} \
  -s /bin/bash \
  -U app

WORKDIR ${APP_DIR}
COPY ${CONTRIB_DIR}/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ${CONTRIB_DIR}/etc/nginx/conf.d/luna.conf /etc/nginx/conf.d/luna.conf
COPY ${CONTRIB_DIR}/etc/luna/rc.lua /etc/luna/rc.lua
COPY ${CONTRIB_DIR}/home/app/run.sh ${APP_DIR}/run.sh

EXPOSE 80/tcp

VOLUME ["/etc/luna/core.lua"]

CMD ["/home/app/run.sh"]
