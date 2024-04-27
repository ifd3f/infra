{
  name = "basics";
  description = "Useful utilities for terminal environments";
  enableByDefault = true;
  progFn = { pkgs }: {
    programs = {
      # Neovim is cool and good
      neovim = {
        enable = true;
        viAlias = true;
      };

      # Just in case the SSH connection is lost and I'm running something long
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
      file
      gh
      git
      git-lfs
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
      exfat
      exfatprogs
      nmap
      p7zip
      pciutils
      psmisc
      python3
      speedtest-rs
      tcpdump
      tree
      unixtools.xxd
      unzip
      usbutils
      uwufetch
      wget
      yq
      zip
    ];
  };
}
