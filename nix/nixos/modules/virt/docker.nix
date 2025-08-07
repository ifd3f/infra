{ pkgs, ... }:
{
  virtualisation.podman.enable = true;
  environment.systemPackages = with pkgs; [ podman-compose ];
}
