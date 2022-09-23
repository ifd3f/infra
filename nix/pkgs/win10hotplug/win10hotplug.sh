#!/bin/sh

xmldir=${WIN10HOTPLUG_XMLDIR:-$(dirname $(readlink -f $0))}
connection="qemu:///system"
dom="win10"

case $1 in
    "attach" | "a")
        action="attach-device"
        ;;
    "detach" | "d")
        action="detach-device"
        ;;
    *)
        echo "Usage: [ a | d ] [ [ g | m | k | u ] ... ]"
        exit 1
esac
shift 1

for short in "$@"; do
    case $short in
        "m")
            name="mouse"
            files=("mouse.xml")
            ;;
        "k")
            name="keyboard"
            files=("ergodox.xml")
            ;;
        "u")
            name="USB controller"
            files=("usbctl.xml")
            ;;
        "g")
            name="GPU"
            files=("gpu-pcie.xml" "gpu-vga.xml" "gpu-audio.xml")
            ;;
        *)
            echo "=== Unknown device $d ==="
            continue
            ;;
    esac

    echo "=== $short - $name ==="

    for file in "${files[@]}"; do
        fullpath="$(readlink -f "$xmldir/$file")"
        echo "Using $fullpath"
        virsh -c "$connection" $action $dom --file "$fullpath" --persistent
    done
done
