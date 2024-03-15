#!/usr/bin/env python3

import os
import re
import subprocess
import sys

MATRICES = {
    'normal': '1 0 0 0 1 0 0 0 1',
    'left': '0 -1 1 1 0 0 0 0 1',
}

COORDINATE_TRANFORM_ATTR = 191


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in MATRICES:
        display_help()
        exit(1)

    for input_id in find_ipts_ids():
        rotate_input_by_id(input_id, sys.argv[1])
    rotate_primary_screen(sys.argv[1])


def rotate_input_by_id(xinput_id: int, rotation: str):
    matrix = MATRICES[rotation]
    cmd = f"xinput set-prop {xinput_id} {COORDINATE_TRANFORM_ATTR} {matrix}"
    os.system(cmd)


def rotate_primary_screen(rotation: str):
    os.system(f'xrandr --output eDP-1 --primary --mode 2736x1824 --pos 0x0 --rotate {rotation}')


def find_ipts_ids():
    xinput_result = subprocess.check_output('xinput', shell=True).decode()
    for l in xinput_result.splitlines():
        if 'IPTS' in l and 'pointer' in l:
            yield int(re.search(r'id=(\d+)', l).group(1))


def display_help():
    print("simple script for rotating the surface's screen")
    print(f"usage: {sys.argv[0]} <normal | left>")


if __name__ == '__main__':
    main()

