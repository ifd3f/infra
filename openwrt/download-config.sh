#!/bin/bash

function download {
    target=$1
    shift
    files="$@"
    if [ -z "$target" ]; then 
        >&2 echo "No openwrt host supplied"
        exit 1
    fi


    (
        for a in $files; do 
            echo uci export $a 
        done
    ) | ssh $target /bin/ash
}

# Export wireless separately because there's wifi passwords
download >outer.uci root@192.168.1.1 \
    dhcp \
    dropbear \
    firewall \
    luci \
    network \
    rpcd \
    system \
    ubootenv \
    ucitrack \
    uhttpd 

download >outer.secret.uci root@192.168.1.1 wireless

download >travel.uci root@10.4.0.1 \
    dhcp \
    dropbear \
    firewall \
    luci \
    network \
    rpcd \
    system \
    ucitrack \
    uhttpd 

download >travel.secret.uci root@10.4.0.1 wireless
