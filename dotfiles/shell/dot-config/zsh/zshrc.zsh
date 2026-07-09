#!/usr/bin/env zsh

for cfg in ~/.config/zsh/zshrc.d/*; do
    source "$cfg"
done

