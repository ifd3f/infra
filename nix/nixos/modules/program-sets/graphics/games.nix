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
      (openttd-jgrpp.overrideAttrs (oldAttrs: {
        src = fetchFromGitHub {
          owner = "JGRennison";
          repo = "OpenTTD-patches";
          rev = "jgrpp-0.69.2";
          sha256 = "sha256-D9Oh05Isf7Atsih6tZBA8xS04aCuE8VS5Ghf0FvrU5A=";
        };
        version = "0.69.2";
      }))
    ];
  };
}
