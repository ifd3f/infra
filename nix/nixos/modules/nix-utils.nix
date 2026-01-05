{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.nix-utils;
in
{
  options.astral.nix-utils = {
    enable = lib.mkEnableOption "astral.nix-utils";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      # Auto-optimize/GC store
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Trusted users for remote config builds and uploads
      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
        auto-optimise-store = true;
      };

      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  };
}
