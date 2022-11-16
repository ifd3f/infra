# Contabo VPS.
{ pkgs, lib, inputs, ... }: {
  imports = [ inputs.self.nixosModules.contabo-vps ];

  astral = {
    ci.deploy-to = "154.53.59.80";
    roles = { server.enable = true; };
  };

  networking.hostName = "bennett";

  time.timeZone = "US/Pacific";

  boot.loader.grub = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    efiSupport = false;
    enable = true;
    version = 2;
  };
}
