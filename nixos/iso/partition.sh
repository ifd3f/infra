#!/bin/bash
# Drive partitioning 
# https://nixos.wiki/wiki/NixOS_on_ZFS#How_to_install_NixOS_on_a_ZFS_root_filesystem
export disk=/dev/disk/by-id/ata-QEMU_HARDDISK_QM00007

sgdisk --zap-all $disk
sgdisk -n1:0:+550M -t1:ef00 $disk
sgdisk -n2:0:0 -t2:bf00 $disk

sleep 2  # wait for /dev/disk/by-partlabel to update

export boot=$disk-part1
export pool=$disk-part2

zpool create rpool $pool
mkfs.vfat $boot

# "Borrowed" from https://grahamc.com/blog/erase-your-darlings
zfs create -p -o mountpoint=legacy rpool/local/root
zfs snapshot rpool/local/root@blank
mount -t zfs rpool/local/root /mnt

mkdir -p /mnt/nix /mnt/boot/efi /mnt/persist

zfs create -p -o mountpoint=legacy rpool/local/nix
mount -t zfs rpool/local/nix /mnt/nix

zfs create -p -o mountpoint=legacy rpool/safe/persist
mount -t zfs rpool/safe/persist /mnt/persist

mount -t vfat $boot /mnt/boot/efi

nixos-generate-config --root /mnt

head -c 8 /etc/machine-id