# These config options are common to EVERYTHING.
{
  pkgs,
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

    astral.pkgsets.basics.enable = true;
    astral.pkgsets.utils.enable = true;
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

    # Enable SSH in initrd for debugging
    boot.initrd.network.ssh = {
      enable = true;
      authorizedKeys = [ config.astral.lib.sshKeyDatabase.users.astrid ];
    };

    boot.tmp.cleanOnBoot = true;
  };
}
