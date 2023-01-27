{ pkgs, lib, config, inputs, ... }:
with lib;
let
  vs = config.vault-secrets.secrets;
  lcfg = config.services.loki;
in {
  # vault kv put kv/loki-server/environment S3_ACCESS=@ S3_SECRET=@
  vault-secrets.secrets.loki-server = { };

  astral.custom-nginx-errors.virtualHosts = [ "loki.astrid.tech" ];

  services.loki = {
    enable = false;

    extraFlags = [ "-config.expand-env=true" ];

    configuration = {
      common = { ring.kvstore.store = "memberlist"; };
      auth_enabled = false;
      compactor = {
        compaction_interval = "5m";
        shared_store = "s3";
        working_directory = "/var/lib/loki/data/compactor";
      };
      ingester = {
        chunk_idle_period = "5m";
        chunk_retain_period = "30s";
        lifecycler = {
          final_sleep = "0s";
          ring.replication_factor = 1;
        };
      };
      limits_config = {
        enforce_metric_name = false;
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };
      memberlist = {
        abort_if_cluster_join_fails = false;
        bind_port = 7946;
        max_join_backoff = "1m";
        max_join_retries = 10;
        min_join_backoff = "1s";
      };
      schema_config = {
        configs = [{
          from = "2023-01-18";
          index = {
            period = "24h";
            prefix = "index_";
          };
          object_store = "s3";
          schema = "v11";
          store = "boltdb-shipper";
        }];
      };
      server = {
        http_listen_address = "0.0.0.0";
        http_listen_port = 3100;
      };
      storage_config = {
        aws = {
          s3 = "https://s3.us-west-000.backblazeb2.com/ifd3f-logging";
          access_key_id = "\${S3_ACCESS}";
          secret_access_key = "\${S3_SECRET}";
          s3forcepathstyle = true;
        };
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/index";
          cache_location = "/var/lib/loki/index_cache";
          shared_store = "s3";
        };
      };
    };
  };

  systemd.services.loki.serviceConfig.EnvironmentFile =
    "${vs.loki-server}/environment";

  services.nginx.virtualHosts = {
    "loki.astrid.tech" = {
      enableACME = true;
      forceSSL = true;

      # TODO: figure out mTLS
      extraConfig = ''
        allow 154.53.59.80;
        allow 173.212.242.107;
        allow 192.9.153.114;
        allow 192.9.241.223;
        allow 208.87.130.175;

        allow 127.0.0.1;
        allow ::1;

        deny all;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:"
          + toString lcfg.configuration.server.http_listen_port;
        proxyWebsockets = true;
      };
    };
  };
}
