{
  name = "dev";
  description = "Development tools";
  progFn = { pkgs }: {
    astral.program-sets = { browsers = true; };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      android-studio
      cachix
      ckan
      cmatrix
      firefox-devedition-bin
      gh
      gitkraken
      imagemagick
      jetbrains.idea-ultimate
      lolcat
      nixfmt
      vagrant
      vscode

      ghidra

      (gnuradio3_8.override {
        extraPackages = with gnuradio3_8Packages; [
          rds
          ais
          grnet
          osmosdr
          limesdr
        ];
      })
      hackrf
      sdrpp
      soapysdr-with-plugins
    ];
  };
}
