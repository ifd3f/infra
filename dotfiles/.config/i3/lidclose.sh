#!/bin/bash

grep -q closed /proc/acpi/button/lid/LID0/state
if [ $? = 0 ]
then
        /home/astrid/.config/i3/lock.sh
fi

