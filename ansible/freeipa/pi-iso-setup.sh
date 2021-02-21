#!/bin/bash

function print_help_msg {
    echo "Install Ubuntu and configure:"
    echo "    $0 <xzipped ubuntu-preinstall ISO> <destination device>"
    echo "Only configure:"
    echo "    $0 <destination device>"
}

function write_iso {
    echo "Writing ISO to $DEVICE"
    xzcat $ISO | dd bs=64M of=$DEVICE status=progress
}

function copy_configs {
    export MNTDIR=/tmp/astrid.tech/freeipa-iso
    echo "Mounting the boot partition at $MNTDIR"
    mkdir -p $MNTDIR
    mount "${DEVICE}1" $MNTDIR

    echo "Copying configs into boot partition"
    cp ipa0-boot/* $MNTDIR -v

    echo "Unmounting boot partition"
    umount $MNTDIR
}

if [ $# -eq 1 ]; then 
    export DEVICE=$1
    echo "I will configure $DEVICE, which has Ubuntu ARM installed on it."

    read -p "Are you sure? " -n 1 -r
    echo
    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting."
        exit 1
    fi

    copy_configs
    exit 0
elif [ $# -eq 2 ]; then 
    export ISO=$1
    export DEVICE=$2

    echo "$DEVICE will be COMPLETELY OVERWRITTEN with Ubuntu ARM!"
    echo "I will use the xzipped $ISO."
    read -p "Are you sure? " -n 1 -r
    echo
    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting."
        exit 1
    fi

    write_iso
    copy_configs

    echo Done
    exit 0
else
    echo "Invalid arguments."
    print_help_msg
    exit 2
fi