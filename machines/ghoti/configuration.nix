inputs:
{ config, pkgs, lib, modulesPath, ... }:
with lib; {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.self.nixosModules.server

    inputs.self.nixosModules.iot-gw
  ];

  astral = {
    monitoring-node.scrapeTransport = "tailscale";
    tailscale.oneOffKey =
      "tskey-auth-kmaxKP6CNTRL-2367V3ZvY17oaxmkCUeEz6wpSaVDixp9K";
  };

  boot.loader.grub.enable = false;
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "ghoti";
    domain = "h.astrid.tech";

    supplicant."wlan0".configFile.path = "/wpa_supplicant.conf";
  };

  time.timeZone = "US/Pacific";

  sdImage.compressImage = false;
}
