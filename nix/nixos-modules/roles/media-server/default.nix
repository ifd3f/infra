# Home media server, hooked up directly to the TV.
{ config, pkgs, lib, ... }:
with lib; {
  services.nginx.virtualHosts."deluge.astrid.tech" = {
    addSSL = true;
    forceSSL = true;

    locations."/".proxyPass =
      "http://localhost:${toString config.services.deluge.web.port}";
  };

  services.xserver = {
    enable = true;
    desktopManager.kodi.enable = true;
  };

  networking.bridges."br-torrent".interfaces = [ "veth-torrent" ];
  networking.interfaces."veth-torrent" = {
    virtual = true;
    ipv4.addresses = [ "10.43.32.1" ];
    ipv6.addresses = [ "fc00::1" ];
  };

  virtualisation.oci-containers = {
    backend = "podman";

    # https://github.com/ilteoood/docker-surfshark
    containers.surfshark = {
      image = "ghcr.io/ilteoood/docker-surfshark:latest";
      environment = {
        SURFSHARK_USER = YOUR_SURFSHARK_USER;
        SURFSHARK_PASSWORD = YOUR_SURFSHARK_PASSWORD;
        CONNECTION_TYPE = "udp";
      };
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun"
        "--network=br-torrent"
        "--ip=10.43.23.2"
      ];
      ports = [ 8123 ];
    };
  };

  containers.deluge = {
    autoStart = true;
    privateNetwork = true;

    hostBridge = "br-torrent";
    hostAddress = "10.43.32.1";
    localAddress = "10.43.32.3";
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
        declarative = true;
        web.enable = true;
      };

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
    };
  };
}
