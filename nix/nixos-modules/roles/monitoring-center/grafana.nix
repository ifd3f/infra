{ pkgs, lib, config, ... }:
with lib;
let
  vs = config.vault-secrets.secrets;
  gcfg = config.services.grafana;
in {
  astral.backup.services.paths = [ "/var/lib/grafana" ];

  # vault kv put kv/grafana-sso-oauth/env GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET=@
  vault-secrets.secrets.grafana-sso-oauth = { environmentKey = "env"; };

  systemd.services.grafana = {
    requires = [ "grafana-sso-oauth-secrets.service" ];
    after = [ "grafana-sso-oauth-secrets.service" ];
    serviceConfig.EnvironmentFile = "${vs.grafana-sso-oauth}/environment";
  };

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
