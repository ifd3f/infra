inputs:
{ config, pkgs, lib, modulesPath, ... }:
with lib; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.self.nixosModules.server

    (import ./boot.nix inputs)
    ./fs.nix
    ./net.nix
  ];

  # Logrotate config build fail workaround
  # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  services.logrotate.checkConfig = false;

  astral = {
    users.alia.enable = true;
    users.astrid.enable = true;
    virt = {
      docker.enable = true;
      libvirt.enable = true;
    };
    monitoring-node.scrapeTransport = "tailscale";
    tailscale.enable = mkForce false;

    backup.db.enable = false;
  };

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "boop";
    domain = "h.astrid.tech";

    hostId = "49e32584"; # Required for ZFS
  };

  services.nginx = {
    enable = true;

    clientMaxBodySize = "16m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };

  virtualisation.vmVariant = {
    # Autologin as root because we testin here
    services.getty.autologinUser = "root";

    networking.interfaces.eth0.useDHCP = true;
    networking.interfaces.eno0.useDHCP = mkForce false;

    virtualisation = {
      graphics = false;
      diskSize = 8192;

      forwardPorts = [
        {
          from = "host";
          host.port = 2222;
          guest.port = 22;
        }
        {
          from = "host";
          guest.port = 80;
          host.port = 8080;
        }
      ];
    };
  };
}
