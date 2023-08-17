inputs:
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

      hostname-admin = "sso.astrid.tech";
      hostname-strict-backchannel = true;

      log-level = "INFO";
    };

    database.passwordFile = "/var/lib/secrets/keycloak/dbpassword";
  };

  services.postgresql.enable = true;

  services.nginx.virtualHosts.${kcfg.settings.hostname} = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString kcfg.settings.http-port}";
      proxyWebsockets = true;
      extraConfig = ''
        # needed to fix the 502's due to header too big
        proxy_busy_buffers_size 512k;
        proxy_buffers 4 512k;
        proxy_buffer_size 256k;

        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };
}
