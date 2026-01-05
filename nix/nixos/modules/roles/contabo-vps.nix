{
  modulesPath,
  config,
  lib,
  ...
}:
let
  cfg = config.astral.roles.contabo-vps;
in
{
  #imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  options.astral.roles.contabo-vps.enable = lib.mkEnableOption "Contabo VPS settings";

  config = lib.mkIf cfg.enable {
    zramSwap.enable = true;

    boot = {
      cleanTmpDir = true;

      # Contabo does not provide EFI, use GRUB
      loader.grub = {
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
        efiSupport = false;
        enable = true;
      };
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
