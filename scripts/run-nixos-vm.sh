#!/bin/sh

vmname=$1

nixos-rebuild build-vm --flake ".#$vmname" && ./result/bin/run-*-vm
