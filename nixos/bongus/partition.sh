#!/bin/bash
# "Borrowed" from https://grahamc.com/blog/erase-your-darlings
export disk=/dev/vda

parted -s $disk mktable gpt
parted -s -a optimal $disk mkpart boot 0% 400MiB  # /boot
parted -s -a optimal $disk mkpart root-zfs-part 400MiB 100%  # zfs

sleep 2  # wait for /dev/disk/by-partlabel to update

export root=$(readlink -f /dev/disk/by-partlabel/root-zfs-part)
export boot=$(readlink -f /dev/disk/by-partlabel/boot)

zpool create rpool $root
mkfs.vfat $boot

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