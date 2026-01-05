{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.virt.docker;
in
{
  options.astral.virt.docker = {
    enable = lib.mkEnableOption "astral.virt.docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;
    environment.systemPackages = with pkgs; [ podman-compose ];
  };
}
