#!/bin/sh

vmname=$1

attr="nixosConfigurations.$vmname.config.system.build.vm"
session="nixvm $vmname"

tmux new-session -d -s session "nix run .#$attr"
tmux new-window "sleep 5; ssh localhost -p 2222"
tmux a
