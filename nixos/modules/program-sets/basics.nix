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
    jq
    mktemp
    python3
    tree
    unixtools.xxd
    yq

    # Password manager
    bitwarden-cli

    # Other utilities
    bind
    ed
    elinks
    iftop
    iotop
    psmisc
    neofetch
    nmap
    pciutils
    unzip
    usbutils
    uwufetch
  ];
}
