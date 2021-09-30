#!/bin/sh

BACKLIGHT="/sys/class/backlight/intel_backlight"
PERCENT=$2 
CURRENT=$(cat $BACKLIGHT/brightness)
MAX=$(cat $BACKLIGHT/max_brightness)
DELTA=$(expr $MAX \* $PERCENT / 100)

case $1 in
    "+")
        RESULT=$(expr $CURRENT + $DELTA)
        RESULT=$(($RESULT > $MAX ? $MAX : $RESULT))
        ;;
    "-")
        RESULT=$(expr $CURRENT - $DELTA)
        RESULT=$(($RESULT < 0 ? 0 : $RESULT))
        ;;
    *)
        echo "Unsupported direction $1"
        exit 1
        ;;
esac

echo $RESULT | sudo /usr/bin/tee $BACKLIGHT/brightness

