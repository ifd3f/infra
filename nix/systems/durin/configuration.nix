# Contabo VPS.
{ pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  astral = { roles.server.enable = true; };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "durin";

  time.timeZone = "US/Pacific";

  services.openssh.enable = true;
}
