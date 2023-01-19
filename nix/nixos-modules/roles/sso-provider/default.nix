{ pkgs, lib, config, ... }:
with lib;
let
  kcfg = config.services.keycloak;

  keystore = rec {
    password = "thepasswordidkitdoesntmatterfuckthisshit";
    file = "${deriv}";
    deriv = pkgs.runCommand "keystore.jks" { } ''
      ${pkgs.jdk}/bin/keytool \
        -storepass ${password} \
        -noprompt \
        -trustcacerts \
        -import \
        -alias ipa0.id.astrid.tech \
        -keystore $out \
        -file ${./ipa0-id-astrid-tech.crt}
    '';
  };
in {
  imports = [ ./ldap-shim.nix ];

  # Trust the LDAP server's cert
  security.pki.certificateFiles = [ ./ipa0-id-astrid-tech.crt ];

  services.keycloak = {
    enable = true;
    settings = {
      proxy = "edge";
      hostname = "sso.astrid.tech";
      http-port = 18433;
      http-host = "0.0.0.0";
      http-enabled = true;

      spi-truststore-file-file = keystore.file;
      spi-truststore-file-password = keystore.password;

      log-level = "DEBUG";
    };
    database = {
      type = "postgresql";
      name = "keycloak";
      username = "username";
      host = "localhost";
      passwordFile = "/var/lib/secrets/keycloak/dbpassword";
    };
  };

  # # Make Java trust it too
  # systemd.services.keycloak.environment.JAVA_ARGS =
  #   "-Djavax.net.ssl.trustStore=${keystore} -Djavax.net.ssl.trustStorePassword=${password}";

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
