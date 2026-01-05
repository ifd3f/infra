# These config options are common to EVERYTHING.
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.astral.roles.common;
in
{
  options.astral.roles.common.enable = lib.mkEnableOption "astral.roles.common";

  config = lib.mkIf cfg.enable {
    nix.package = pkgs.lixPackageSets.stable.lix;
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
      home-manager
    ];

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "corefonts"
        "helvetica-neue-lt-std"
        "vista-fonts"
      ];
  };
}
