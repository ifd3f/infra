{ pkgs, lib, config, ... }:
with lib;
let kcfg = config.services.keycloak;
in {
  services.keycloak = {
    enable = true;
    settings = {
      proxy = "edge";
      hostname = "sso.astrid.tech";
      http-port = 18433;
      http-host = "0.0.0.0";
      http-enabled = true;

      log-level = "DEBUG";
    };
    database = {
      type = "postgresql";
      name = "keycloak";
      username = "keycloak";
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
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-For $proxy_protocol_addr;
      '';
    };
  };
}
