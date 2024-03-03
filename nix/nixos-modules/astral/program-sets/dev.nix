{
  name = "dev";
  description = "Development tools";
  progFn = { pkgs }: {
    astral.program-sets = { browsers = true; };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      android-studio
      cachix
      cargo
      ckan
      cmatrix
      efibootmgr
      gh
      ghidra
      hackrf
      cabal-install
      hping
      imagemagick
      lolcat
      nixfmt
      racket
      refind
      sdrpp
      soapysdr-with-plugins
      testdisk
      vscode
      wireshark

      (gnuradio3_8.override {
        extraPackages = with gnuradio3_8Packages; [
          rds
          ais
          grnet
          osmosdr
          limesdr
        ];
      })
    ];
  };
}
