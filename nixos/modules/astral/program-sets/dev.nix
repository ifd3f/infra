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
      vscode-fhs

      gnuradio
      hackrf
      sdrpp
    ];
  };
}
