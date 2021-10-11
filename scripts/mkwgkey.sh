#!/usr/bin/env sh

name=$1
wg genkey | tee "$name.key" | wg pubkey > "$name.pub"