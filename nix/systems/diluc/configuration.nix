# Contabo VPS.
{ pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ./akkoma.nix ];

  astral = {
    acme.enable = true;
    roles.server.enable = true;
  };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "diluc";

  time.timeZone = "Europe/Berlin";

  boot.loader.grub = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    efiSupport = false;
    enable = true;
    version = 2;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.enable = true;

  virtualisation.vmVariant = {
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
      {
        from = "host";
        guest.port = 80;
        host.port = 8080;
      }
      {
        from = "host";
        guest.port = 443;
        host.port = 8443;
      }
    ];
  };
}
