/*
  Regularly updates the system from this flake repo.
  Wraps around system.autoUpdate and customized for
  my stuff, but provides additional helper options.
*/
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.astral.infra-update = with lib; {
    enable = mkOption {
      description = "Enable to periodically update from the infra repo.";
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
      type = types.str;
    };

    build-host = mkOption {
      description = "The remote host to compile the config on. If null, builds it on itself.";
      default = null;
      type = types.nullOr types.str;
    };
  };

  config.system.autoUpgrade =
    let
      cfg = config.astral.infra-update;
    in
    lib.mkIf cfg.enable {
      enable = cfg.enable;
      flake = "github:ifd3f/infra/${cfg.branch}";
      dates = "*-*-* *:00:00";
      flags = (
        if cfg.build-host == null then
          [ ]
        else
          [
            "--build-host"
            cfg.build-host
          ]
      );
    };
}
