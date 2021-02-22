#!/bin/bash

function print_help_msg {
    echo "Install Ubuntu and configure:"
    echo "    $0 <config folder> <xzipped ubuntu-preinstall ISO> <destination device>"
    echo "Only configure:"
    echo "    $0 <config folder> <destination device>"
}

function write_iso {
    echo "Writing ISO to $DEVICE"
    xzcat $ISO | dd of=$DEVICE status=progress
    sync
}

function copy_configs {
    export MNTDIR=/tmp/cloud.astrid.tech/ubuntu-pi-iso-setup
    echo "Mounting the boot partition at $MNTDIR"
    mkdir -p $MNTDIR
    mount "${DEVICE}1" $MNTDIR

    echo "Copying configs into boot partition"
    cp $CONFIG/* $MNTDIR -v

    echo "Unmounting boot partition"
    umount $MNTDIR
}

if [ $# -eq 2 ]; then 
    export CONFIG=$1
    export DEVICE=$2
    echo "Using device with installed Ubuntu: $DEVICE"
    echo "Config folder: $CONFIG"

    read -p "Are you sure? (y/n)" -n 1 -r
    echo
    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting."
        exit 1
    fi

    copy_configs
    echo Done
    exit 0
elif [ $# -eq 3 ]; then 
    export CONFIG=$1
    export ISO=$2
    export DEVICE=$3

    export DEVICE_MIB=`echo \`sudo blockdev --getsize64 /dev/sdb\` / 1024 / 1024 | bc`

    echo "Zipped ISO: $ISO"
    echo "Config folder: $CONFIG"
    echo "OVERWRITING DEVICE: $DEVICE ($DEVICE_MIB MiB)"
    read -p "Are you sure? (y/n)" -n 1 -r
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