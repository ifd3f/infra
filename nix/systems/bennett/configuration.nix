# Contabo VPS.
{ pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  astral = {
    roles = { server.enable = true; };
  };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "bennett";

  time.timeZone = "Europe/Berlin";

  boot.loader.grub = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    efiSupport = false;
    enable = true;
    version = 2;
  };
}
