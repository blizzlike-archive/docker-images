#!/bin/bash

export CORE_DIR=${CORE_DIR:-/home/core}

cmake ../development \
  -DUSE_ANTICHEAT=0 \
  -DCMAKE_INSTALL_PREFIX=${CORE_DIR}/run \
  -DUSE_EXTRACTORS=1 \
  -DUSE_LIBCURL=1 \
  -DDEBUG=0

make -j4
