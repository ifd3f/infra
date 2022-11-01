#!/bin/sh

set -e

vmname=$1

target=".#nixosConfigurations.$vmname.config.system.build.vm"
session="nixvm $vmname"

nix build --no-link "$target"
tmux new-session -d -s session "nix run $target"
tmux new-window "sleep 10; ssh localhost -p 2222"
tmux a
