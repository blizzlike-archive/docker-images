#!/bin/bash

function cma {
  cd ~/build
  cmake ../core -DUSE_ANTICHEAT=0 \
    -DCMAKE_INSTALL_PREFIX=/home/lightshope/run \
    -DUSE_EXTRACTORS=1
}
