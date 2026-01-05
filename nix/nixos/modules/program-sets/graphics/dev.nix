{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.graphics.dev;
in
{
  options.astral.program-sets.graphics.dev = {
    enable = lib.mkEnableOption "astral.program-sets.graphics.dev";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      android-tools
      cabal-install
      cachix
      cargo
      ckan
      cmatrix
      efibootmgr
      gh
      ghidra
      hping
      imagemagick
      lolcat
      netcat
      nixfmt-rfc-style
      racket
      refind
      testdisk
      virt-manager
      vscode
      wireshark
    ];
  };
}
