#!/bin/sh

cat /dev/random | head -c 4 | xxd -p
