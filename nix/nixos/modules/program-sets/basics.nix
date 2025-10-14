{ pkgs, ... }:
let
  python3-custom = (
    pkgs.python3.withPackages (
      ps: with ps; [
        aiohttp
        click
        pandas
        pytest
        requests
      ]
    )
  );
in
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
    hdparm
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
    ntfs3g
    p7zip
    pciutils
    psmisc
    python3-custom
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
