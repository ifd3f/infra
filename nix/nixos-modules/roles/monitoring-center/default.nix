{ pkgs, lib, config, inputs, ... }:
with lib;
let
  vs = config.vault-secrets.secrets;
  gcfg = config.services.grafana;
in {
  astral.backup.services.paths = [ "/var/lib/grafana" "/var/lib/prometheus2" ];

  vault-secrets.secrets = {
    grafana-sso-oauth = {
      # vault kv put kv/grafana-sso-oauth/env GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET=@
      environmentKey = "env";
    };

    # vault kv put kv/prometheus-xmpp-alerts/environment XMPP_USER_PASSWORD=@
    prometheus-xmpp-alerts = { };
  };

  systemd.services.grafana = {
    requires = [ "grafana-sso-oauth-secrets.service" ];
    after = [ "grafana-sso-oauth-secrets.service" ];
    serviceConfig.EnvironmentFile = "${vs.grafana-sso-oauth}/environment";
  };

  astral.custom-nginx-errors.virtualHosts = [ "grafana.astrid.tech" ];

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.astrid.tech";
        http_port = 2342;
        addr = "127.0.0.1";
        root_url = "https://grafana.astrid.tech";
      };

      "auth.generic_oauth" = {
        name = "IFD3F Technologies";
        icon = "signin";
        enabled = true;

        client_id = "internal-grafana";
        client_secret = "SECRET THAT GETS OVERRIDEN";
        scopes = "openid email profile offline_access roles";

        auth_url =
          "https://sso.astrid.tech/realms/public-users/protocol/openid-connect/auth";
        token_url =
          "https://sso.astrid.tech/realms/public-users/protocol/openid-connect/token";
        api_url =
          "https://sso.astrid.tech/realms/public-users/protocol/openid-connect/userinfo";
        email_attribute_path = "email";
        login_attribute_path = "username";
        name_attribute_path = "full_name";
        role_attribute_path =
          "contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer'";
        allow_sign_up = true;
      };
    };
  };

  users.groups.prometheus-xmpp-alerts-secrets = { };

  systemd.services.prometheus-xmpp-alerts.serviceConfig.EnvironmentFile =
    "${vs.prometheus-xmpp-alerts}/environment";

  services.prometheus = {
    enable = true;
    checkConfig = "syntax-only";

    xmpp-alerts = {
      enable = true;
      settings = {
        jid = "alertmanager@xmpp.femboy.technology";
        to_jid = "ifd3f@xmpp.femboy.technology";
        password_command = "echo $XMPP_USER_PASSWORD";
        listen_address = "127.0.0.1";
        listen_port = 9199;
      };
    };

    scrapeConfigs = let
      ecfg = config.services.prometheus.exporters;
      tls_config = {
        # ca_file = "${../../ca.crt}";
        # cert_file = "${./prometheus.pem}";
        # key_file = cfg.sslKeyFile;
      };
      targets = [
        "amiya.h.astrid.tech"
        "bennett.h.astrid.tech"
        "diluc.h.astrid.tech"
        "durin.h.astrid.tech"
        "yato.h.astrid.tech"
      ];
    in [
      {
        inherit tls_config;

        scheme = "https";
        job_name = "node";
        scrape_interval = "10s";
        metrics_path = "/metrics/node";
        static_configs = [{ inherit targets; }];
      }
      {
        inherit tls_config;

        scheme = "https";
        job_name = "nginx";
        scrape_interval = "10s";
        metrics_path = "/metrics/nginx";
        static_configs = [{ inherit targets; }];
      }
      {
        inherit tls_config;

        scheme = "https";
        job_name = "nginxlog";
        scrape_interval = "10s";
        metrics_path = "/metrics/nginxlog";
        static_configs = [{ inherit targets; }];
      }
      {
        inherit tls_config;

        scheme = "https";
        job_name = "systemd";
        scrape_interval = "10s";
        metrics_path = "/metrics/systemd";
        static_configs = [{ inherit targets; }];
      }
      {
        inherit tls_config;

        scheme = "https";
        job_name = "bind";
        scrape_interval = "10s";
        metrics_path = "/metrics/bind";
        static_configs = [{ targets = [ "diluc.h.astrid.tech" ]; }];
      }
      {
        inherit tls_config;

        scheme = "https";
        job_name = "postgres";
        scrape_interval = "10s";
        metrics_path = "/metrics/postgres";
        static_configs =
          [{ targets = [ "amiya.h.astrid.tech" "diluc.h.astrid.tech" ]; }];
      }
      {
        scheme = "http";
        job_name = "akkoma";
        scrape_interval = "5s";
        metrics_path = "/";
        static_configs = [{ targets = [ "localhost:8895" ]; }];
      }
    ];
  };

  services.akkoma-prometheus-exporter."fedi.astrid.tech" = {
    enable = true;
    port = 8895;
  };

  services.nginx.virtualHosts = {
    "${gcfg.settings.server.domain}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass =
          "http://127.0.0.1:${toString gcfg.settings.server.http_port}";
        proxyWebsockets = true;

        # needed to prevent 'Origin not allowed'
        # see: https://community.grafana.com/t/after-update-to-8-3-5-origin-not-allowed-behind-proxy/60598/4
        extraConfig = ''
          proxy_set_header Host grafana.astrid.tech;
        '';
      };
    };
  };
}
