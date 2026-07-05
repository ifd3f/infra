{
  modulesPath,
  config,
  lib,
  ...
}:
let
  cfg = config.astral.roles.contabo-vps;
  qemu-guest = modulesPath + "/profiles/qemu-guest.nix";
in
{
  options.astral.roles.contabo-vps.enable = lib.mkEnableOption "Contabo VPS settings";

  config = lib.mkIf cfg.enable {
    zramSwap.enable = true;

    services.qemuGuest.enable = true;

    boot = {
      cleanTmpDir = true;

      kernelParams = [
        "console=tty0"
        "boot.shell_on_fail"
      ];

      # Contabo does not provide EFI, use GRUB
      loader.grub = {
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
        efiSupport = false;
        enable = true;
      };

      loader.timeout = 3;
    };

    networking = {
      useDHCP = lib.mkDefault true;

      # IPv6 connectivity
      # See also: https://contabo.com/blog/adding-ipv6-connectivity-to-your-server/
      defaultGateway6 = {
        address = "fe80::1";
        interface = "ens18";
      };

      interfaces.ens18.useDHCP = lib.mkDefault true;
    };
  };
}
