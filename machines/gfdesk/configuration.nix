inputs:
{ config, pkgs, lib, modulesPath, ... }:
with lib; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.self.nixosModules.server

    inputs.self.nixosModules.akkoma

    ./boot.nix
    ./fs.nix
    ./net.nix
    ./share.nix
    ./deluge.nix
  ];

  # Logrotate config build fail workaround
  # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  services.logrotate.checkConfig = false;

  astral = {
    users.alia.enable = true;
    virt = {
      docker.enable = true;
      libvirt.enable = true;
    };
    monitoring-node.scrapeTransport = "tailscale";
    tailscale.oneOffKey =
      "tskey-auth-kw1UVH6CNTRL-SfhN6EEVv3A74NvnoJRA5Azutj6eJYwVc";

    backup.db.enable = false;
  };

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "gfdesk";
    domain = "h.astrid.tech";

    hostId = "6d1020a1"; # Required for ZFS

    firewall.allowedTCPPorts = [ 5432 ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "akkoma" ];
    ensureUsers = [{
      name = "akkoma";
      ensureDBOwnership = true;
    }];

    settings = {
      listen_addresses = mkForce "*";
      ssl = "on";
      ssl_cert_file = "/var/lib/postgresql/server.crt";
      ssl_key_file = "/var/lib/postgresql/server.key";

      full_page_writes = "off"; # Postgres runs on zfs

      # random bullshit go
      shared_buffers = "8GB";
      effective_cache_size = "24GB";
      maintenance_work_mem = "2GB";
      work_mem = "16MB";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
      checkpoint_completion_target = "0.9";
      wal_buffers = "16MB";
      random_page_cost = "1.1";
      effective_io_concurrency = "200";
      max_worker_processes = 16;
      max_parallel_workers_per_gather = 4;
      max_parallel_workers = 16;
      max_parallel_maintenance_workers = 4;
      default_statistics_target = 100;

      # Adjust the minimum time to collect the data
      log_min_duration_statement = "10s";
      log_autovacuum_min_duration = 0;

      # Query stats
      shared_preload_libraries = "pg_stat_statements";
      "pg_stat_statements.max" = 10000;
      "pg_stat_statements.track" = "all";
    };

    authentication = ''
      hostssl all akkoma 0.0.0.0/0 md5
      hostssl all akkoma ::/0 md5
    '';
  };

  services.nginx = {
    enable = true;

    clientMaxBodySize = "16m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };
}
