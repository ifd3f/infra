# Updates the system from this flake repo every hour.
# Wraps around infra-update, but provides additional 
# helper options.

{ config, pkgs, ... }: {
  options.astral.infra-update = with pkgs.lib; {
    enable = mkOption {
      description = "Enable to update from the infra repo on the hour.";
      default = false;
      type = types.bool;
    };

    dates = mkOption {
      description = "SystemD date spec. By default, on the hour.";
      default = "*-*-* *:00:00"; 
      type = types.str;
    };

    branch = mkOption {
      description = "What branch to track.";
      default = "main";
      type = types.string;
    };

    build-host = mkOption {
      description = "The remote host to compile the config on. If null, builds it on itself.";
      default = null;
      type = types.nullOr types.string;
    };
  };
  
  config.system.autoUpgrade = let cfg = config.astral.infra-update; in {
    enable = cfg.enable;
    flake = "github:astralbijection/infra/${cfg.branch}";
    dates = "*-*-* *:00:00";
    flags = (
      if cfg.build-host == null
        then []
        else ["--build-host" cfg.build-host]
    );
  };
}
