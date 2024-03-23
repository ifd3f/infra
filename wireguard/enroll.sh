#!/usr/bin/env bash

set -euo pipefail

hostname=$(hostname)
username=$(whoami)
filename="$username@$hostname"
dstdir="$HOME/.config/nyahaus-wireguard/"
private_key="$dstdir/private.key"

umask 077
mkdir -p "$dstdir"
chmod 700 "$dstdir"

echo "writing private key to $private_key"
wg genkey > "$private_key"
chmod 600 "$private_key"

echo "writing public key to $filename.pub"
umask 777
cat "$private_key" | wg pubkey | tee "$filename.pub"

