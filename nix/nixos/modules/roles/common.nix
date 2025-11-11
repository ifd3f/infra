# These config options are common to EVERYTHING.
{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    "${inputs.self}/nix/nixos/modules/program-sets/basics.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/utils.nix"

    "${inputs.self}/nix/nixos/modules/custom-tty"
    "${inputs.self}/nix/nixos/modules/mount-root-to-home.nix"
    "${inputs.self}/nix/nixos/modules/nix-utils.nix"
    "${inputs.self}/nix/nixos/modules/sshd.nix"
    "${inputs.self}/nix/nixos/modules/users.nix"
  ];

  #nix.package = pkgs.lixPackageSets.stable.lix;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "corefonts"
    "helvetica-neue-lt-std"
    "vista-fonts"
  ];
}
