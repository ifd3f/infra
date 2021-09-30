#!/bin/sh

output=$($HOME/.config/i3/get-window-criteria.sh)
echo $output | dmenu

