#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <key> <csr>"
    exit 1
fi

key="$1"
csr="$2"

set -euxo pipefail

openssl ca -config openssl.conf -name CA_root -in "$csr" -keyfile "$key"

