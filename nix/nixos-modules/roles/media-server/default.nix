# Home media server, hooked up directly to the TV.
{ config, pkgs, lib, ... }:
with lib; {
  services.nginx.virtualHosts."deluge.s02.astrid.tech" = {
    locations."/".proxyPass = let container = config.containers.deluge;
    in "http://${container.localAddress}"
    + ":${toString container.config.services.deluge.web.port}";
  };

  services.xserver = {
    enable = true;
    desktopManager.kodi.enable = true;
  };

  networking.bridges."br-torrent".interfaces = [ ];
  networking.interfaces."br-torrent" = {
    ipv4.addresses = [{
      address = "10.16.50.1";
      prefixLength = 24;
    }];
    ipv6.addresses = [{
      address = "fc00::1";
      prefixLength = 24;
    }];
  };

  virtualisation.oci-containers = {
    backend = "podman";

    # https://github.com/ilteoood/docker-surfshark
    containers.surfshark = {
      image = "ghcr.io/ilteoood/docker-surfshark:1.3.0";
      environment = {
        SURFSHARK_USER = "YOUR_SURFSHARK_USER";
        SURFSHARK_PASSWORD = "YOUR_SURFSHARK_PASSWORD";
        CONNECTION_TYPE = "udp";
      };
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun"
        "--network=br-torrent"
        "--ip=10.43.23.2"
      ];
    };
  };

  containers.deluge = {
    autoStart = true;
    privateNetwork = true;

    hostBridge = "br-torrent";
    hostAddress = "10.16.50.1";
    localAddress = "10.16.50.3";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::3";

    bindMounts = {
      "/srv/deluge" = {
        hostPath = "/srv/deluge";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      system.stateVersion = "22.05";

      services.deluge = {
        enable = true;
        web.enable = true;
      };

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ config.services.deluge.web.port ];
      };
    };
  };
}
