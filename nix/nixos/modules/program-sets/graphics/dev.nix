{ pkgs, ... }:
{
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
}
