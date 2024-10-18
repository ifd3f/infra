inputs:
{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
with lib;
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    inputs.self.nixosModules.server
  ];

  astral = {
    monitoring-node.enable = mkForce false;
    tailscale.enable = mkForce false;
  };

  boot.loader.grub.enable = false;
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "squid";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";

  sdImage.compressImage = false;
}
