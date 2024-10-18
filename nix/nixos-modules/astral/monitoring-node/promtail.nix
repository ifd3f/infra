{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.astral.monitoring-node;
in
{
  config = mkIf cfg.enable {
    services.promtail = {
      enable = true;
      configuration = {
        clients = [ { url = "https://loki.astrid.tech/loki/api/v1/push"; } ];
        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              json = true;
              path = "/var/log/journal";
              max_age = "12h";
              labels = {
                host = cfg.vhost;
                job = "journal";
                "__path__" = "/var/log/journal";
              };
            };

            relabel_configs = [
              {
                source_labels = [ "__journal__systemd_unit" ];
                target_label = "unit";
              }
              {
                source_labels = [ "__journal_priority" ];
                target_label = "priority";
              }
              {
                source_labels = [ "__journal_syslog_identifier" ];
                target_label = "syslog_id";
              }
            ];
          }

          {
            job_name = "nginx";
            static_configs = [
              {
                labels = {
                  host = cfg.vhost;
                  job = "nginx";
                  __path__ = "/var/log/nginx/*";
                };
              }
            ];
          }
        ];

        server = {
          http_listen_port = 9832;
          http_path_prefix = "/promtail";
          grpc_listen_port = 0;
        };
      };
    };

    services.nginx.virtualHosts."${cfg.vhost}".locations = {
      "/promtail".proxyPass =
        let
          promtailPort = config.services.promtail.configuration.server.http_listen_port;
        in
        "http://127.0.0.1:${toString promtailPort}/metrics";
    };

    users.users.promtail.extraGroups = [ "nginx" ];
  };
}
