{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.roles.sso-provider;
  kcfg = config.services.keycloak;
in {
  options.astral.roles.sso-provider.enable =
    mkEnableOption "SSO provider server role";

  config = mkIf cfg.enable {
    services.keycloak = {
      enable = true;
      settings = {
        proxy = "edge";
        hostname = "sso.astrid.tech";
        http-port = 18433;
        http-host = "127.0.0.1";

        hostname-admin-url = "https://sso.astrid.tech";
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
        proxyPass =
          "http://127.0.0.1:${toString kcfg.settings.http-port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
    };
  };
}
