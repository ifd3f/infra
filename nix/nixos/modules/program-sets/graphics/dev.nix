{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    android-tools
    cachix
    cargo
    ckan
    cmatrix
    efibootmgr
    gh
    ghidra
    cabal-install
    hping
    imagemagick
    lolcat
    nixfmt-rfc-style
    racket
    refind
    testdisk
    vscode
    wireshark
  ];
}
