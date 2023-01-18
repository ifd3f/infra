#!/bin/sh

f=$(mktemp)

cat | yq -r > "$f"
nix eval --expr "builtins.fromJSON (builtins.readFile $f)" --impure
