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
        echo "Usage: [ a | d ] [ [ m | k | u ] ... ]"
        exit 1
esac
shift 1

for d in "$@"; do
    case $d in
        "m")
            file="mouse.xml"
            ;;
        "k")
            file="ergodox.xml"
            ;;
        "u")
            file="usbctl.xml"
            ;;
        *)
            echo "Unknown device $d"
            continue
            ;;
    esac
    virsh -c $connection $action $dom --file "$xmldir/$file"
done
