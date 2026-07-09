# Potentially needed nix path settings on non-NixOS
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}

# Default editor for other commands
export EDITOR=vi

