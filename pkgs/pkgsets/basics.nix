/**
  This package set goes on EVERYTHING.

  This even includes our planned appliance machines!
  Try not to make this set excessively big.
*/
{
  description = "Bare minimum CLI utilities good for debugging on all machines";

  selector =
    pkgs:
    with pkgs;
    [
      age
      curl
      fio
      dnsutils
      ed
      elinks
      envsubst
      file
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
      pciutils
      ripgrep
      rsync
      tcpdump
      tmux
      tree
      libarchive
      lz4
      smartmontools
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
      efibootmgr
      hdparm
      iotop
      iputils
      lshw
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
