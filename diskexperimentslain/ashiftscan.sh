#!/usr/bin/env bash

# This script scans through zfs ashift values on a disk and attempts to find one that works.

set -euxo pipefail

jobsdir=/home/astrid/del
disk=/dev/nvme0n1

for ashift in 9 10 11 12 13 14; do
	cd /

	zpool create testpool -o ashift="$ashift" "$disk"
	cd /testpool
	fio --output-format=json+ --output=/home/astrid/ashift$ashift.json --alloc-size=1024 $jobsdir/*.fio

	cd /
	zpool destroy -f testpool
done
