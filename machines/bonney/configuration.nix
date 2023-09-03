inputs:
{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel

    inputs.self.nixosModules.server

    inputs.self.nixosModules.media-server
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  astral = {
    monitoring-node.scrapeTransport = "tailscale";
    tailscale.oneOffKey =
      "tskey-auth-ka8GwW6CNTRL-buTFdt8S7P7Cmpwb1uQiM797EGYiPfc3";
  };

  networking = {
    hostName = "bonney";
    domain = "h.astrid.tech";
    hostId = "f0097b23";

    networkmanager.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "US/Pacific";

  programs.steam.enable = true;

  virtualisation.podman.enable = true;
  virtualisation.vmVariant = {
    # Autologin as root because we testin here
    services.getty.autologinUser = "root";

    # Route request to deluge web
    services.nginx.virtualHosts."localhost".locations."/" = {
      proxyPass = "http://localhost:80";
      extraConfig = ''
        proxy_set_header Host "deluge.s02.astrid.tech";
      '';
    };

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

  system.stateVersion = mkForce "23.05"; # Did you read the comment?
}
