# Contabo VPS.
{ pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  astral = {
    ci.deploy-to = "192.9.241.223";
    roles.server.enable = true;
  };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "durin";

  time.timeZone = "US/Pacific";

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
}
