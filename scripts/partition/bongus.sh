#!/usr/bin/env bash
# Drive partitioning 
# https://nixos.wiki/wiki/NixOS_on_ZFS#How_to_install_NixOS_on_a_ZFS_root_filesystem
# Ephemeral root idea "borrowed" from https://grahamc.com/blog/erase-your-darlings

function log_info {
    echo "==== $1 ===="
}

if [ -z $root_disk ]; then
    log_info "Please specify a root_disk env var"
    exit 1
fi

if [ -z $zfs_disk ]; then
    log_info "Please specify a zfs_disk env var"
    exit 1
fi

# Make partition table and partitions
log_info "Rewriting partition tables"

# The root disk must be MBR so that we can boot off of it
parted -s $root_disk -- mklabel msdos # Clear table
parted -s $root_disk -- mkpart primary fat32 1MiB 550MiB  # Boot
parted -s $root_disk -- mkpart primary ext4 550MiB 10GiB  # (ephemeral) Root
parted -s $root_disk -- mkpart primary xfs 10GiB 100%  # VM disks

# The ZFS disk(s) are GPT cuz it's better and we *don't* boot off of it
sgdisk --zap-all $zfs_disk

log_info "Done. Waiting for /dev/disk/by-id to update..."
sleep 3 

# Format partitions
export boot=$root_disk-part1
export root=$root_disk-part2
export vmdisk=$root_disk-part3

log_info "Formatting $boot as FAT"
mkfs.vfat $boot

log_info "Formatting $root as ext4"
mkfs.ext4 -F $root

log_info "Formatting $vmdisk as XFS"
mkfs.xfs -f $vmdisk

log_info "Creating ZFS pool dpool on $zfs_disk"
zpool create dpool $zfs_disk
zfs create -p -o mountpoint=legacy dpool/local/nix
zfs create -p -o mountpoint=legacy dpool/safe/persist

# Create mountpoints and mount
log_info "Mounting..."
mkdir -p /mnt 
mount -t ext4 $root /mnt

mkdir -p /mnt/nix /mnt/boot /mnt/persist
mount -t zfs dpool/local/nix /mnt/nix
mount -t zfs dpool/safe/persist /mnt/persist
mount -t vfat $boot /mnt/boot

log_info "Generated skeleton!"
tree --device /mnt

log_info "Populating NixOS configs..."
mkdir -p /mnt/etc/nixos 
cd /mnt/etc/nixos 
GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/astralbijection/infra.git infra
echo "import ./infra/nixos/bootstrap-bongus.nix" > configuration.nix
nixos-install -j 32 --no-root-passwd
