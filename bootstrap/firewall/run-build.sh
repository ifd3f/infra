#!/bin/bash

git clone -b current --single-branch https://github.com/vyos/vyos-build /vyos/vyos-build

cd /vyos/vyos-build
os=buster64 branch=equuleus make build

./configure \
    --architecture=amd64 \
    --build-by="astrid@astrid.tech" \
    --custom-package=cloud-init

sudo make iso