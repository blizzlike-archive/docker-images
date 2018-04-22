#!/bin/bash

function cma {
  cd ~/build
  cmake ../lh-core -DUSE_ANTICHEAT=0 \
    -DCMAKE_INSTALL_PREFIX=${CORE_DIR}/run \
    -DUSE_EXTRACTORS=1
}
