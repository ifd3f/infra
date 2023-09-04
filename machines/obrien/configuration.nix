inputs:
{ config, pkgs, lib, modulesPath, ... }:
with lib; {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.self.nixosModules.server
    inputs.self.nixosModules.octoprint
  ];

  astral = {
    monitoring-node.enable = mkForce false;
    tailscale.enable = mkForce false;
  };

  boot.loader.grub.enable = false;
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "obrien";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";

  sdImage.compressImage = false;
}
