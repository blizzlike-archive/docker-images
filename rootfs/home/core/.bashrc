#!/bin/bash

export CORE_DIR=${CORE_DIR:-/home/core}

function cma {
  if [ ! -h ${CORE_DIR}/core ]; then
    echo "Missing symlink to core sources"
    echo "run: ln -s ~/development/<path/to/core> ~/core"
    exit 1
  fi
  cd ~/build
  cmake ../core \
    -DUSE_ANTICHEAT=0 \
    -DCMAKE_INSTALL_PREFIX=${CORE_DIR}/run \
    -DUSE_EXTRACTORS=1 \
    -DUSE_LIBCURL=1 \
    -DDEBUG=0
}
