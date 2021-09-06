#!/usr/bin/env bash
# Drive partitioning 
# https://nixos.wiki/wiki/NixOS_on_ZFS#How_to_install_NixOS_on_a_ZFS_root_filesystem
# Ephemeral root idea "borrowed" from https://grahamc.com/blog/erase-your-darlings

if [ -z $root_disk ]; then
    echo "Please specify a root_disk env var"
    exit 1
fi

if [ -z $zfs_disk ]; then
    echo "Please specify a zfs_disk env var"
    exit 1
fi

# Make partition table and partitions
echo "Rewriting partition table"
sgdisk --zap-all $root_disk  # Clear root disk
sgdisk -n1:0:+550M -t1:ef00 $root_disk  # Boot
sgdisk -n2:0:+10G -t2:bf00 $root_disk  # (ephemeral) Root
sgdisk -n3:0:0 -t2:bf00 $root_disk  # VM boot drive space

sgdisk --zap-all $zfs_disk

echo "Done. Waiting for /dev/disk/by-id to update..."
sleep 3 

# Format partitions
export boot=$root_disk-part1
export root=$root_disk-part2
export vmdisk=$root_disk-part3

echo "Formatting $boot as FAT"
mkfs.vfat $boot

echo "Formatting $root as ext4"
mkfs.ext4 -F $root

echo "Formatting $vmdisk as XFS"
mkfs.xfs -f $vmdisk

echo "Creating ZFS pool dpool on $zfs_disk"
zpool create dpool $zfs_disk
zfs create -p -o mountpoint=legacy dpool/local/nix
zfs create -p -o mountpoint=legacy dpool/safe/persist

# Create mountpoints and mount
echo "Mounting..."
mkdir -p /mnt 
mount -t ext4 $root /mnt

mkdir -p /mnt/nix /mnt/boot /mnt/persist
mount -t zfs dpool/local/nix /mnt/nix
mount -t zfs dpool/safe/persist /mnt/persist
mount -t vfat $boot /mnt/boot

# Generate our config
nixos-generate-config --root /mnt

echo "Generated NixOS skeleton!"
tree /mnt
