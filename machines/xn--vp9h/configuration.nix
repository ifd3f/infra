inputs:
{ config, pkgs, lib, modulesPath, ... }:
with lib; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.self.nixosModules.server

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
      "tskey-auth-kAYrVT7CNTRL-KwYTz4f64XK8yDjkZ9ydVKhRdTm47NpVN";

    backup.db.enable = false;
  };

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "xn--vp9h";
    domain = "h.astrid.tech";

    hostId = "dab38c19"; # Required for ZFS
  };

  services.nginx = {
    enable = true;

    clientMaxBodySize = "16m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };
}
