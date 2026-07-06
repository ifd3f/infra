{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.astral.nix-utils;
in
{
  options.astral.nix-utils = {
    enable = mkEnableOption "Custom Nix tweaks";
    priority = mkOption {
      description = ''
        What priority should Nix get?

        The vast majority of my machines call Nix rarely and intermittently.
        Therefore, "low" priority is set as the default so that updates and
        builds don't kill the system.
      '';
      type = types.enum [
        "low"
        "stock"
      ];
      default = "low";
    };
  };

  config = mkIf cfg.enable {
    nix = mkMerge [
      (mkIf (cfg.priority == "low") {
        daemonIOSchedPriority = 7; # lowest pri

        # "idle" is designed for interactive use.
        daemonIOSchedClass = "idle";
        daemonCPUSchedPolicy = "idle";
      })
      {
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
      }
    ];
  };
}
