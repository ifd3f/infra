if [ $# -ne 1 ]; then
    echo "Give me a device"
    exit 1
fi

export DEVICE=$1
export BOOT_PARTITION="${DEVICE}1"
export MAIN_PARTITION="${DEVICE}2"

export MNTDIR=/tmp/cloud.astrid.tech/ipa0
echo "Mounting the boot partition ($BOOT_PARTITION) at $MNTDIR"
mkdir -p $MNTDIR
mount $BOOT_PARTITION $MNTDIR

echo "Touching /boot/ssh"
touch $MNTDIR/ssh

echo "Unmounting boot partition"
umount $MNTDIR

echo "Mounting the main partition ($MAIN_PARTITION) at $MNTDIR"
mkdir -p $MNTDIR
mount $MAIN_PARTITION $MNTDIR

echo "Copying patches in"
cp -r ipa0/* $MNTDIR

echo "Unmounting main partition"
umount $MNTDIR

