#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <slotid>"
    exit 1
fi

slot="$1"
serial="$(ykman info | grep 'Serial number:' | awk '{print $3;}')"

set -euxo pipefail

pubfile="./yk$serial.pub"
csrfile="./yk$serial.csr"
subject="CN=I.YK.$serial iykyk,C=US,ST=California,L=San Francisco,O=astrid dot tech,OU=DevSecAICatGoonGitChatOps"

ykman piv keys generate -a RSA2048 "$slot" "$pubfile"
ykman piv certificates request --subject "$subject" "$slot" "$pubfile" "$csrfile"

