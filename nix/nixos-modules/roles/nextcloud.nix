{ config, pkgs, lib, ... }:
with lib; {
  astral.backup.services.paths = [ config.services.nextcloud.home ];

  # vault kv put kv/nextcloud/secrets s3_secret=@
  vault-secrets.secrets.nextcloud = { };

  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "nextcloud.astrid.tech";
    logLevel = 0;
    maxUploadSize = "16G";

    config.objectstore.s3 = {
      enable = true;
      hostname = "s3.us-west-000.backblazeb2.com";
      bucket = "ifd3f-nextcloud";
      usePathStyle = true;
      key = "";
      secretFile =
        "${config.vault-secrets.secrets.nextcloud}/s3_secret";
    };
  };
}
