{ pkgs, ... }:
{
  astral.program-sets = {
    dev = true;
    kbflash = true;
    office = true;
    security = true;
  }

  environment.systemPackages = [
    home-manager.defaultPackage."x86_64-linux"
    openconnect
  ];

  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };
}