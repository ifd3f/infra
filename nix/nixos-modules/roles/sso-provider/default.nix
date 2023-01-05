{ pkgs, lib, config, ... }:
with lib;
let kcfg = config.services.keycloak;
in {
  services.keycloak = {
    enable = true;
    settings = {
      proxy = "none";
      hostname = "sso.astrid.tech";
      http-port = 18433;
      http-host = "127.0.0.1";

      hostname-admin-url = "https://sso.astrid.tech/auth";
      hostname-port = 443;
    };
    database = {
      type = "postgresql";
      name = "keycloak";
      username = "username";
      host = "localhost";
      passwordFile = "/var/lib/secrets/keycloak/dbpassword";
    };
  };

  services.postgresql = {
    ensureDatabases = [ kcfg.database.name ];
    ensureUsers = [{
      name = kcfg.database.username;
      ensurePermissions = {
        "DATABASE \"${kcfg.database.name}\"" = "ALL PRIVILEGES";
      };
    }];
  };

  services.nginx.virtualHosts.${kcfg.settings.hostname} = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString kcfg.settings.http-port}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_pass_request_headers on;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };
}
