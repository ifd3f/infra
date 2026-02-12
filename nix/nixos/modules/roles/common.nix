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

    astral.program-sets.basics.enable = true;
    astral.program-sets.utils.enable = true;
    astral.custom-tty.enable = true;
    astral.sshd.enable = true;
    astral.nix-utils.enable = true;

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
