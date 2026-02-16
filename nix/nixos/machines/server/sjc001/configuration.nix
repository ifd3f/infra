{
  config,
  pkgs,
  lib,
  inputs,
  modulesPath,
  ...
}:
with lib;
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  astral = {
    roles.server.enable = true;
    roles.contabo-vps.enable = true;
    roles.auth-dns.enable = true;

    make-disk-image = {
      enable = true;
      rootGPUID = "032cd687-b0fc-43a1-8117-a0307543afc3";
      rootFSUID = "5943b8e5-743c-4436-8107-f85331271a3f";
      testSimpleVMGB = 32;
    };
    acme.enable = true;
  };

  # Logrotate config build fail workaround
  # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  services.logrotate.checkConfig = false;

  networking = {
    hostName = "sjc001";
    hostId = "3b957bce";
    domain = "h.astrid.tech";

    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  time.timeZone = "US/Pacific";

  services.nginx = {
    enable = true;

    clientMaxBodySize = "16m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };
}
