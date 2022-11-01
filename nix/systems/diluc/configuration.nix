# Contabo VPS.
{ pkgs, lib, ... }: {
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
    config = let inherit ((pkgs.formats.elixirConf { }).lib) mkRaw;
    in {
      ":pleroma"."Pleroma.Web.Endpoint".url.host = "fedi.astrid.tech";
      ":pleroma".":media_proxy".enabled = true;
      ":pleroma".":instance" = {
        name = "da astrid z0ne";
        description = "astrid's akkoma server";
        email = "akkoma@astrid.tech";
        notify_email = "akkoma@astrid.tech";
        registrations_open = false;
      };

      ":pleroma"."Pleroma.Upload" = {
        uploader = mkRaw "Pleroma.Uploaders.S3";
        base_url = "https://s3.us-west-000.backblazeb2.com";
        strip_exif = false;
      };
      ":pleroma"."Pleroma.Uploaders.S3".bucket = "nyaabucket";
      ":ex_aws".":s3" = {
        access_key_id._secret = "/var/lib/secrets/akkoma/b2_app_key_id";
        secret_access_key._secret = "/var/lib/secrets/akkoma/b2_app_key";
        host = "s3.us-west-000.backblazeb2.com";
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
