#!/usr/bin/env bash

while true; do
    xinput list --name-only 'keyboard:Microsoft Surface Type Cover Keyboard' > /dev/null
    echo $?
    sleep 1
done

