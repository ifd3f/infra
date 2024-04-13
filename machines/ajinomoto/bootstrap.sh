#!/bin/sh

make_zpool() {
  zpool create ajinomoto raidz3 \
    /dev/disk/by-id/wwn-0x5000cca03b9b5f00 \
    /dev/disk/by-id/wwn-0x5000cca05c5b9eec \
    /dev/disk/by-id/wwn-0x5000cca05c9fd908 \
    /dev/disk/by-id/wwn-0x5000cca05ca387b0 \
    /dev/disk/by-id/wwn-0x5000cca05ca82394 \
    /dev/disk/by-id/wwn-0x5000cca05caa4814 \
    /dev/disk/by-id/wwn-0x5000cca05caa6590 \
    /dev/disk/by-id/wwn-0x5000cca05cab52e0 \
    /dev/disk/by-id/wwn-0x5000cca05cbc8f9c \
    /dev/disk/by-id/wwn-0x5000cca05cc7c110 \
    /dev/disk/by-id/wwn-0x5000cca05ccc91e0 \
    /dev/disk/by-id/wwn-0x5000cca05cd50144
}

setup_zpool() {
  zfs set mountpoint=none compression=lz4 ajinomoto
  zfs create -o mountpoint=legacy ajinomoto/boot
  zfs create -o mountpoint=legacy ajinomoto/nix
  zfs create -o encryption=on -o keyformat=passphrase ajinomoto/enc
  zfs create -o mountpoint=legacy ajinomoto/enc/var
  zfs create -o mountpoint=legacy ajinomoto/enc/etc
  zfs create -o mountpoint=legacy ajinomoto/enc/tmp
  zfs create -o mountpoint=legacy ajinomoto/enc/home
}

mount_disks() {
  mount -t tmpfs -o size=256M,mode=755 rootfs /mnt
  mount -o x-mount.mkdir /dev/disk/by-uuid/1f75c5dd-1fc2-4300-8946-cb8c327231af /mnt/boot
  mount -t zfs -o x-mount.mkdir ajinomoto/nix /mnt/nix
  mount -t zfs -o x-mount.mkdir ajinomoto/enc/etc /mnt/etc
  mount -t zfs -o x-mount.mkdir ajinomoto/enc/tmp /mnt/tmp
  mount -t zfs -o x-mount.mkdir ajinomoto/enc/var /mnt/var
  mount -t zfs -o x-mount.mkdir ajinomoto/enc/home /mnt/home
}