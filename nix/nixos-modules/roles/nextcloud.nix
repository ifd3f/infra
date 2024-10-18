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

  # vault kv put kv/nextcloud-db/secrets dbpass=@ oidc_login_client_secret=@
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

    extraOptions = {
      oidc_login_client_id = "nextcloud";
      oidc_login_provider_url = "https://sso.astrid.tech/realms/public-users";
      oidc_login_end_session_redirect = false;
      oidc_login_logout_url =
        "https://nextcloud.astrid.tech/apps/oidc_login/oidc";
      oidc_login_auto_redirect = false;
      oidc_login_redir_fallback = false;
      oidc_login_attributes = {
        id = "preferred_username";
        mail = "email";
      };
      oidc_login_button_text = "Log in with IFD3F SSO";

      overwriteprotocol = "https";
    };

    secretFile = "/var/lib/nextcloud/secrets.json";
  };

  services.nginx.virtualHosts."nextcloud.astrid.tech" = {
    enableACME = true;
    forceSSL = true;
  };

  users = {
    users.nextcloud.extraGroups = [ "nextcloud-secrets" ];
    groups.nextcloud-secrets = { };
  };

  systemd.services.nextcloud-assemble-secret-json = {
    requires = [ "nextcloud-db-secrets.service" ];
    path = with pkgs; [ jq ];
    environment = {
      oidcsecretpath = "${vs.nextcloud-db}/oidc_login_client_secret";
      secretout = config.services.nextcloud.secretFile;
    };
    script = ''
      umask 007
      rm -f $secretout
      jq -rn --arg oidcsecret $(cat "$oidcsecretpath") \
        '{oidc_login_client_secret: $oidcsecret, }' > $secretout
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
    };
  };

  systemd.services.nextcloud-setup = {
    requires = [
      "nextcloud-secrets.service"
      "nextcloud-db-secrets.service"
      "nextcloud-assemble-secret-json.service"
    ];
    after = [
      "nextcloud-secrets.service"
      "nextcloud-db-secrets.service"
      "nextcloud-assemble-secret-json.service"
    ];
  };

  systemd.services.phpfpm-nextcloud = {
    requires = [ "nextcloud-setup.service" ];
    after = [ "nextcloud-setup.service" ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [{
      name = "nextcloud";
      ensureDBOwnership = true;
    }];
  };
}
