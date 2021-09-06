# A minimal environment, but it is still somewhat comfortable to debug.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Editors are always helpful
    neovim

    # Download stuff from the internet
    git
    curl
    wget

    # Just in case the SSH connection is lost and I'm running something long
    tmux

    # Useful scripting utilities
    envsubst
    tree
    jq
    yq
  ];
}
