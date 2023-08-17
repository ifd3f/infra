inputs:
{ config, pkgs, lib, ... }:
with lib; {
  imports =
    [ ./hardware-configuration.nix inputs.self.nixosModules.server ./net.nix ];

  astral = {
    # Disable for now because it simply can't be reached
    monitoring-node.enable = mkForce false;

    tailscale.enable = mkForce false;
    virt.libvirt.enable = true;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      splashImage = ./nether.jpg;
    };
  };

  hardware.enableRedistributableFirmware = false;

  networking = {
    hostName = "inferno";
    domain = "h.astrid.tech";
    hostId = "49e32584";
  };

  time.timeZone = "US/Pacific";
}
