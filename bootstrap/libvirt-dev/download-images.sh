#!/bin/bash

function download() {
    url=$1
    dest=$2

    if [ -f $dest ]; then
        echo "Already exists: $dest"
        return
    fi

    echo "Downloading to $dest: $url"
    curl -sSL $url -o "images/$dest"
}

download \
    "https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso" \
    "debian.iso" 

download \
    "https://download.fedoraproject.org/pub/fedora/linux/releases/34/Server/x86_64/iso/Fedora-Server-dvd-x86_64-34-1.2.iso" \
    "fedora.iso"

download \
    "https://nyifiles.netgate.com/mirror/downloads/pfSense-CE-2.5.2-RELEASE-amd64.iso.gz" \
    "pfsense.iso.gz"

gunzip -k pfsense.iso.gz