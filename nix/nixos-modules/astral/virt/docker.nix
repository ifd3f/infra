{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.astral.virt.docker = {
    enable = mkOption {
      description = "Use docker stuff";
      default = false;
      type = types.bool;
    };
  };

  config =
    let
      cfg = config.astral.virt.docker;
    in
    mkIf cfg.enable {
      virtualisation.podman.enable = true;
      environment.systemPackages = with pkgs; [ podman-compose ];
    };
}
