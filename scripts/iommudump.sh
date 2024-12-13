#!/bin/sh

echo "=== LSPCI ==="
lspci -QkPDvvv
echo

echo "=== LSUSB ==="
lsusb -tvv
echo

echo "=== IOMMU GROUPS ==="
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done
done
echo

echo "=== USB IOMMU GROUPS ==="
for usb_ctrl in /sys/bus/pci/devices/*/usb*; do
    pci_path=${usb_ctrl%/*}
    iommu_group=$(readlink $pci_path/iommu_group)
    echo "Bus $(cat $usb_ctrl/busnum) --> ${pci_path##*/} (IOMMU group ${iommu_group##*/})"
    lsusb -s ${usb_ctrl#*/usb}:
    echo
done