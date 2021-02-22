if [ $# -ne 1 ]; then
    echo "Give me a device"
    exit 1
fi

export DEVICE=$1
export MAIN_PARTITION="${DEVICE}1"

export MNTDIR=/tmp/cloud.astrid.tech/rpi-os-enable-ssh
echo "Mounting the boot partition at $MNTDIR"
mkdir -p $MNTDIR
mount $MAIN_PARTITION $MNTDIR

echo "Touching /boot/ssh"
touch $MNTDIR/ssh

echo "Unmounting boot partition"
umount $MNTDIR

