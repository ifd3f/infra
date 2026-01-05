{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.program-sets.graphics.games;
in
{
  options.astral.program-sets.graphics.games = {
    enable = lib.mkEnableOption "astral.program-sets.graphics.games";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      # localNetworkGameTransfers.openFirewall = true;
    };

    # programs.gamescope.enable = true;

    # nixpkgs.config.packageOverrides = pkgs: {
    #   steam = pkgs.steam.override {
    #     extraPkgs = pkgs: with pkgs; [
    #       gamescope
    #     ];
    #   };
    # };

    environment.systemPackages = with pkgs; [
      gamescope
      lutris
      prismlauncher
    ];
  };
}
