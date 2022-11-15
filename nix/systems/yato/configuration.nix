# Contabo VPS.
{ pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  astral = { roles.server.enable = true; };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "yato";

  time.timeZone = "US/Pacific";

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
}
