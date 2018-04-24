#!/bin/bash

export CORE_DIR=${CORE_DIR:-/home/core}

cmake ../development \
  -DUSE_ANTICHEAT=0 \
  -DCMAKE_INSTALL_PREFIX=${CORE_DIR}/run \
  -DUSE_EXTRACTORS=1 \
  -DUSE_LIBCURL=1 \
  -DDEBUG=0 \
  -DCMAKE_CXX_COMPILER=g++-6 \
  -DCMAKE_C_COMPILER=gcc-6

make -j4
