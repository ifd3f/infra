# Contabo VPS.
{ lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  astral.roles.server.enable = true;

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

  services.akkoma = {
    enable = true;
    config = {
      ":pleroma" = {
        ":instance" = {
          name = "da astrid z0ne";
          description = "astrid's akkoma server";
          email = "akkoma@astrid.tech";
          notify_email = "akkoma@astrid.tech";
          registration_open = false;
        };

        ":media_proxy" = { enabled = false; };

        "Pleroma.Web.Endpoint" = { url.host = "fedi.astrid.tech"; };
      };
    };

    nginx = {
      enableACME = true;
      forceSSL = true;
    };
  };

  services.nginx.enable = true;

  services.postgresql.enable = true;

  virtualisation.vmVariant = {
    services.akkoma.nginx = {
      enableACME = lib.mkForce false;
      forceSSL = lib.mkForce false;
    };

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
    ];
  };
}
