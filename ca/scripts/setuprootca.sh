#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <privkey>"
    exit 1
fi

privkey="$1"

set -euxo pipefail

mkdir -p certs newcerts crl
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber

# ~20 year certificate
openssl req -x509 -config ./openssl.conf -section rootreq -key "$1" -days 7000 -text | tee ./certs/ca.crt

