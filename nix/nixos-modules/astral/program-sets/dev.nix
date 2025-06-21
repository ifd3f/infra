{
  name = "dev";
  description = "Development tools";
  progFn = { pkgs }: {
    astral.program-sets = { browsers = true; };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
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
      nixfmt-rfc-style
      racket
      refind
      sdrpp
      soapysdr-with-plugins
      testdisk
      vscode
      wireshark

      gnuradio
    ];
  };
}
