#!/bin/sh

if [ -z $1 ]; then
  echo "Usage: $0 [host-to-deploy-to]"
  exit 2
fi

set -o xtrace

host=$1

nixos-rebuild switch \
  --flake ".#$host" \
  --target-host "$host.h.astrid.tech" \
  --use-remote-sudo