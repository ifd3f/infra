{
  name = "CLI Basics";

  selector =
    pkgs:
    with pkgs;
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
    [
      bind
      curl
      dnsutils
      ed
      elinks
      envsubst
      ethtool
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
      neovim
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
      tmux
      tree
      unar
      unixtools.xxd
      unzip
      usbutils
      wget
      yq
      zip
    ];

  nixos = {
    programs = {
      neovim = {
        enable = true;
        viAlias = true;
      };
      tmux.enable = true;
    };
  };
}
