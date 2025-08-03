{ pkgs, ... }:
{
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
    };

    tmux.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bind
    curl
    dnsutils
    ed
    elinks
    envsubst
    ethtool
    exfat
    exfatprogs
    file
    gh
    git
    git-lfs
    gnumake
    iftop
    inetutils
    iotop
    iperf
    iputils
    jq
    magic-wormhole
    mktemp
    neofetch
    netcat
    nmap
    p7zip
    pciutils
    psmisc
    python3
    ripgrep
    rsync
    speedtest-rs
    tcpdump
    tree
    unar
    unixtools.xxd
    unzip
    usbutils
    uwufetch
    wget
    yq
    zip
  ];
}
