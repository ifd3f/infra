#!/bin/bash
# "Borrowed" from https://grahamc.com/blog/erase-your-darlings
export disk=/dev/vda

parted -s $disk mktable gpt
parted -s -a optimal $disk mkpart boot 0% 400MiB  # /boot
parted -s -a optimal $disk mkpart root-zfs-part 400MiB 100%  # zfs

export root=$(readlink -f /dev/disk/by-partlabel/root-zfs-part)
export boot=$(readlink -f /dev/disk/by-partlabel/boot)

zpool create rootpool $root

zfs create -p -o mountpoint=legacy rootpool/local/root
zfs snapshot rootpool/local/root@blank
mount -t zfs rootpool/local/root /mnt

zfs create -p -o mountpoint=legacy rootpool/local/nix
mkdir /mnt/nix
mount -t zfs rootpool/local/nix /mnt/nix

zfs create -p -o mountpoint=legacy rootpool/safe/persist
mkdir /mnt/persist
mount -t zfs rootpool/safe/persist /mnt/persist

mkfs.vfat $boot
mkdir /mnt/boot
mount -t vfat $boot /mnt/boot

nixos-generate-config --root /mnt