if [ $# -ne 1 ]; then
    echo "Give me a device"
    exit 1
fi

export DEVICE=$1
export MAIN_PARTITION="${DEVICE}3"

echo "Growing device partition and resizing volume"
growpart $DEVICE 3
resize2fs $MAIN_PARTITION

export MNTDIR=/tmp/cloud.astrid.tech/fedora-pi-conf
echo "Mounting the boot partition at $MNTDIR"
mkdir -p $MNTDIR
mount $MAIN_PARTITION $MNTDIR

echo "Growing the XFS filesystem"
xfs_growfs -d $MNTDIR

# See https://raspberrypi.stackexchange.com/questions/90546/fedora-29-on-3b-headless-install
echo "Removing root's password and allowing login"
sed -i 's/:!locked:/:*:/' $MNTDIR/etc/shadow
sed -i 's/:!locked:/:*:/' $MNTDIR/etc/shadow-
sudo sed -i 's/root:x:/root::/' $MNTDIR/etc/passwd
sudo sed -i 's/root:x:/root::/' $MNTDIR/etc/passwd-

echo "Unmounting boot partition"
umount $MNTDIR

