#!/bin/bash

target=$1
if [ -z "$target" ]; then 
    echo "No openwrt host supplied"
    exit 
fi

ssh $target uci export > config.uci