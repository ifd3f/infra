{ config, pkgs, lib, ... }:
with lib;
let vs = config.vault-secrets.secrets;
in {
  astral.backup.services.paths = [ config.services.nextcloud.home ];

  # vault kv put kv/nextcloud/secrets s3_secret=@ adminpass=@
  vault-secrets.secrets.nextcloud = {
    user = "nextcloud";
    group = "nextcloud-secrets";
  };

  # vault kv put kv/nextcloud-db/secrets dbpass=@
  vault-secrets.secrets.nextcloud-db = {
    user = "nextcloud";
    group = "nextcloud-secrets";
  };

  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "nextcloud.astrid.tech";
    logLevel = 0;
    maxUploadSize = "16G";

    config = {
      adminpassFile = "${vs.nextcloud}/adminpass";

      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbname = "nextcloud";
      dbhost = "/run/postgresql";
      dbpassFile = "${vs.nextcloud-db}/dbpass";

      objectstore.s3 = {
        enable = true;
        autocreate = false;
        usePathStyle = true;

        hostname = "s3.us-west-000.backblazeb2.com";
        bucket = "ifd3f-nextcloud";
        key = "0003f10c25ba33d000000001e";
        secretFile = "${vs.nextcloud}/s3_secret";
      };
    };
  };

  services.nginx.virtualHosts."nextcloud.astrid.tech" = {
    enableACME = true;
    forceSSL = true;
  };

  users = {
    users.nextcloud.extraGroups = [ "nextcloud-secrets" ];
    groups.nextcloud-secrets = { };
  };

  systemd.services.nextcloud-setup = {
    requires = [ "nextcloud-secrets.service" "nextcloud-db-secrets.service" ];
    after = [ "nextcloud-secrets.service" "nextcloud-db-secrets.service" ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [{
      name = "nextcloud";
      ensurePermissions = { "DATABASE \"nextcloud\"" = "ALL PRIVILEGES"; };
    }];
  };
}
