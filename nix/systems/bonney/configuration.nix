# A NUC that's my media server, hooked up to the telly
{ pkgs, lib, inputs, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    ./intel-7260-fix.nix

    inputs.self.nixosModules.server

    inputs.self.nixosModules.media-server
  ];

  # Apparently, Linux Zen prevents 7260 issue from happening
  # https://bbs.archlinux.org/viewtopic.php?pid=1830360#p1830360
  boot.kernelPackages = mkForce pkgs.linuxPackages_zen;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  astral = {
    monitoring-node.scrapeTransport = "tailscale";
    tailscale.oneOffKey =
      "tskey-auth-kFWFLk5CNTRL-RAV9nFFeYsfE4LzP9g5ErfmDptdyAcy4A";
  };

  networking = {
    hostName = "bonney";
    domain = "h.astrid.tech";
    hostId = "49e32584";

    networkmanager.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "US/Pacific";

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
