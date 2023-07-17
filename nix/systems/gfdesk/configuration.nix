# The desk that is used by Good Friends.
{ lib, inputs, modulesPath, ... }:
with lib; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.self.nixosModules.server

    inputs.self.nixosModules.akkoma

    ./boot.nix
    ./fs.nix
    ./net.nix
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

    backup.db.enable = true;
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
      ensurePermissions = { "DATABASE \"akkoma\"" = "ALL PRIVILEGES"; };
    }];

    settings = {
      listen_addresses = mkForce "*";
      ssl = "on";
      ssl_cert_file = "/var/lib/postgresql/server.crt";
      ssl_key_file = "/var/lib/postgresql/server.key";
    };

    authentication = ''
      hostssl all akkoma 0.0.0.0/0 md5
      hostssl all akkoma ::/0 md5
    '';
  };
}
