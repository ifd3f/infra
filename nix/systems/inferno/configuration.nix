# Firewall VM host machine.
{ pkgs, lib, inputs, modulesPath, ... }:
with lib; {
  imports =
    [ ./hardware-configuration.nix inputs.self.nixosModules.server ./net.nix ];

  astral = {
    monitoring-node.scrapeTransport = "tailscale";
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
