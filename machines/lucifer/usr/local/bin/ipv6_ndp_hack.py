#!/usr/local/bin/python3
"""
This service exists because for some fucking reason this machine
is dropping neighbor advertisements. I don't know why it's doing that
and I have given up on fixing it, so this hack will be in place.

The following have been observed:
  - the firewall is not seeing neighbor solicits
  - the server is generating neighbor solicits
  - none of the switches in between are dropping neighbor solicits
  - ping server -> firewall won't insert a NDP entry
  - ping firewall -> server will insert a NDP entry on both ends
  - a single ping of firewall -> server allows server -> firewall to
    continue to work due to the cached NDP entry

Therefore, this service will continuously ping the other host once
every 10s to ensure that NDP entry exists.
"""

import subprocess
import time

INTERVAL_SECONDS = 10

targets = [
    "fd67:113:7c37:3339::2",
    "fd67:113:7c37:3339::3",
]


def main():
    while True:
        ping_all()
        time.sleep(INTERVAL_SECONDS)


def ping_all():
    procs = [
        subprocess.Popen(["ping", "-c", "1", "-t", "1", t], stdout=subprocess.DEVNULL)
        for t in targets
    ]
    for p in procs:
        p.wait()


if __name__ == "__main__":
    main()
