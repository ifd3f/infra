#!/bin/bash
# Drive partitioning 
# https://nixos.wiki/wiki/NixOS_on_ZFS#How_to_install_NixOS_on_a_ZFS_root_filesystem

# Ephemeral root idea "borrowed" from https://grahamc.com/blog/erase-your-darlings
# We won't be using ZFS root, but XFS reformatted every boot
export root_disk=/dev/disk/by-id/ata-QEMU_HARDDISK_QM00007

# Make partition table and partitions
sgdisk --zap-all $root_disk
sgdisk -n1:0:+550M -t1:ef00 $root_disk
sgdisk -n2:0:+10G -t2:bf00 $root_disk
sgdisk -n3:0:0 -t2:bf00 $root_disk

sleep 2  # wait for /dev/disk/by-id to update

# Format partitions
export boot=$root_disk-part1
export root=$root_disk-part2
export pool=$root_disk-part3

mkfs.vfat $boot

mkfs.ext4 $root

zpool create rpool $pool
zfs create -p -o mountpoint=legacy rpool/local/nix
zfs create -p -o mountpoint=legacy rpool/safe/persist

# Create mountpoints and mount
mkdir -p /mnt 
mount -t ext4 $root /mnt

mkdir -p /mnt/nix /mnt/boot/efi /mnt/persist
mount -t zfs rpool/local/nix /mnt/nix
mount -t zfs rpool/safe/persist /mnt/persist
mount -t vfat $boot /mnt/boot/efi

# Generate our config
nixos-generate-config --root /mnt
