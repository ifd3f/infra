{ pkgs, ... }:
{
  astral.program-sets = {
    browsers = true;
    cad = true;
    dev = true;
    development = true;
    kbflash = true;
    office = true;
    security = true;
  };

  environment.systemPackages = [
    home-manager.defaultPackage."x86_64-linux"
    openconnect
  ];

  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };
}