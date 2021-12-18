# A minimal environment, but it is still somewhat comfortable to debug.
{ pkgs, ... }: {
  programs = {
    # Neovim is cool and good
    neovim = {
      enable = true;
      viAlias = true;
    };

    # Just in case the SSH connection is lost and I'm running something long
    tmux = { enable = true; };
  };

  environment.systemPackages = with pkgs; [
    # Download stuff from the internet
    git
    git-lfs
    curl
    wget

    # Useful scripting utilities
    envsubst
    tree
    jq
    yq

    # Password manager
    bitwarden-cli

    # Other utilities
    iotop
    elinks
    nmap
    xxd-vim
  ];
}
