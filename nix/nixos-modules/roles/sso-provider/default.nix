{ pkgs, lib, config, ... }:
let
  cfg = {
    theme = "auto";
    default_redirection_url = "https://astrid.tech/";

    server = {
      disable_healthcheck = false;
      enable_expvars = false;
      enable_pprof = false;
      host = "0.0.0.0";
      path = "";
      port = 9091;
    };

    authentication_backend = {
      refresh_interval = "1m";
      ldap = {
        implementation = "activedirectory";
        url = "ldaps://ipa0.id.astrid.tech";
        timeout = "5s";
        tls.server_name = "ipa0.id.astrid.tech";
        base_dn = "dc=astrid,dc=tech";
        username_attribute = "uid";
      };
    };
    log.level = "debug";
    ntp = {
      address = "time.cloudflare.com:123";
      disable_failure = false;
      disable_startup_check = false;
      max_desync = "3s";
      version = 4;
    };
    password_policy = {
      standard = {
        enabled = false;
        max_length = 0;
        min_length = 8;
        require_lowercase = true;
        require_number = true;
        require_special = true;
        require_uppercase = true;
      };
      zxcvbn = {
        enabled = false;
        min_score = 3;
      };
    };
    regulation = {
      ban_time = "5m";
      find_time = "2m";
      max_retries = 3;
    };
    session = {
      expiration = "1h";
      inactivity = "5m";
      name = "authelia_session";
      remember_me = "1M";
      same_site = "lax";
    };
    telemetry.metrics = {
      enabled = true;
      address = "tcp://0.0.0.0:9959";
    };
  };

  validatedCfg = with pkgs;
    runCommand "validated" { json = builtins.toJSON cfg; } ''
      echo "$json" > $out
      ${authelia-bin}/bin/authelia validate-config --config $out
    '';
in {
  systemd.services.authelia = {
    description = "Authelia authentication and authorization server";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];

    path = with pkgs; [ authelia-bin ];
    script = "authelia --config ${validatedCfg}";

    serviceConfig.SyslogIdentifier = "authelia";
  };

  # Trust the LDAP server's cert
  security.pki.certificateFiles = [ ./ipa0-id-astrid-tech.crt ];

  services.nginx.virtualHosts."sso.astrid.tech" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString cfg.server.port}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-For $proxy_protocol_addr;
      '';
    };
  };
}
