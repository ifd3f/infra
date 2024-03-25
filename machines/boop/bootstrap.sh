#!/usr/bin/env bash

set -euxo pipefail

mkdisks() {
  zpool create rpool mirror /dev/disk/by-id/nvme-eui.6479a7869ad03b89 /dev/disk/by-id/nvme-eui.6479a7869ad04a16
  zfs create -o encryption=on -o keylocation=prompt -o keyformat=passphrase rpool/enc
  zfs set mountpoint=none rpool
  zfs set compression=on rpool
  for pool in rpool/enc/var rpool/enc/etc rpool/enc/tmp rpool/enc/home rpool/nix; do
    zfs create -o mountpoint=legacy $pool
  done
  zfs list
}

mountdisks() {
  mount -t tmpfs -o size=256M,mode=755 rootfs /mnt
  mount -t zfs -o x-mount.mkdir rpool/enc/tmp /mnt/tmp
  mount -t zfs -o x-mount.mkdir rpool/nix /mnt/nix
  mount -t zfs -o x-mount.mkdir rpool/enc/var /mnt/var
  mount -t zfs -o x-mount.mkdir rpool/enc/etc /mnt/etc
  mount -t zfs -o x-mount.mkdir rpool/enc/home /mnt/home
  mount -o x-mount.mkdir /dev/disk/by-uuid/D30E-26C7 /mnt/boot
}

runinstall() {
  nixos-install --no-channel-copy --option substituters "" $@
}