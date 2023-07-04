# The desk that is used by Good Friends.
{ config, lib, pkgs, inputs, ... }:
with lib; {
  imports = [ ./hardware-configuration.nix inputs.self.nixosModules.server ];

  astral = {
    users.alia.enable = true;
    virt = {
      docker.enable = true;
      libvirt.enable = true;
    };
    monitoring-node.scrapeTransport = "tailscale";
    tailscale.enable = mkForce false;
  };

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "gfdesk";
    domain = "h.astrid.tech";

    hostId = "6d1020a1"; # Required for ZFS
    useDHCP = false;
  };

  # Use the GRUB boot loader. Note that HP G8 only supports BIOS, not UEFI.
  boot.loader.grub = {
    enable = true;
    copyKernels = true;
    device = "/dev/disk/by-id/usb-HP_iLO_Internal_SD-CARD_000002660A01-0:0";
  };
}
