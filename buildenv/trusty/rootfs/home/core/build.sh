#!/bin/bash

set -e

export CORE_DIR=${CORE_DIR:-/home/core}

cmake ../development \
  -DUSE_ANTICHEAT=0 \
  -DCMAKE_INSTALL_PREFIX=${CORE_DIR}/core \
  -DUSE_EXTRACTORS=1 \
  -DUSE_LIBCURL=1 \
  -DDEBUG=0 \
  -DCMAKE_CXX_COMPILER=g++-6 \
  -DCMAKE_C_COMPILER=gcc-6 \
  -DUSE_GENERIC_CXX_FLAGS=1

make -j4
make install

tar cJf ../release/core-trusty.tar.xz -C ../ ./core
