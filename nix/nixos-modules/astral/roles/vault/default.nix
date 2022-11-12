{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.roles.vault;
  vcfg = config.services.vault;
in {
  options.astral.roles.vault = {
    enable = mkEnableOption "HashiCorp Vault server role";
    exposeToInternet = mkEnableOption "Whether to expose it to the internet";
  };

  config = mkIf cfg.enable {
    services.vault = {
      enable = true;
      storageBackend = "file";
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
  };
}
