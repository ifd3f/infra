{ config, pkgs, lib, ... }:
with lib;
let vs = config.vault-secrets.secrets.nextcloud;
in {
  astral.backup.services.paths = [ config.services.nextcloud.home ];

  # vault kv put kv/nextcloud/secrets s3_secret=@ adminpass=@
  vault-secrets.secrets.nextcloud = { group = "nextcloud-secrets"; };

  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "nextcloud.astrid.tech";
    logLevel = 0;
    maxUploadSize = "16G";

    config = {
      adminpassFile = "${vs}/adminpass";

      objectstore.s3 = {
        enable = true;
        autocreate = false;
        usePathStyle = true;

        hostname = "s3.us-west-000.backblazeb2.com";
        bucket = "ifd3f-nextcloud";
        key = "0003f10c25ba33d000000001e";
        secretFile = "${vs}/s3_secret";
      };
    };
  };

  users = {
    users.nextcloud.extraGroups = [ "nextcloud-secrets" ];
    groups.nextcloud-secrets = { };
  };
}
