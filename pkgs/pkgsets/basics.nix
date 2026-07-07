{
  description = "CLI Basics";

  selector =
    pkgs:
    with pkgs;
    [
      bind
      curl
      dnsutils
      ed
      elinks
      envsubst
      exfat
      file
      gh
      git
      git-lfs
      gnumake
      iftop
      inetutils
      iperf
      jq
      magic-wormhole
      mktemp
      neovim
      netcat
      nmap
      ntfs3g
      p7zip
      pciutils
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

      (pkgs.python3.withPackages (
        ps: with ps; [
          aiohttp
          click
          pandas
          pytest
          requests
        ]
      ))
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      ethtool
      hdparm
      iotop
      iputils
      psmisc
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
