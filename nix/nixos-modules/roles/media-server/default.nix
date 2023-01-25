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

  containers.deluge = {
    autoStart = true;
    privateNetwork = true;

    hostBridge = "br-torrent";
    localAddress = "10.16.50.3/24";
    localAddress6 = "fc00::3/64";

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

      services.resolved = {
        enable = true;
        # From surfshark conf
        fallbackDns = [ "162.252.172.57" "149.154.159.92" ];
      };

      networking = {
        useHostResolvConf = false;

        defaultGateway.address = "10.16.50.2";
        defaultGateway6.address = "fc00::2";

        firewall = {
          enable = true;
          allowedTCPPorts = [ config.services.deluge.web.port ];
        };
      };

      services.getty.autologinUser = "root";
    };
  };

  containers.surfshark = {
    autoStart = true;
    privateNetwork = true;

    hostBridge = "br-torrent";
    localAddress = "10.16.50.3/24";
    localAddress6 = "fc00::3/64";

    config = { config, pkgs, ... }: {
      system.stateVersion = "22.05";

      services.resolved = {
        enable = true;
        # From surfshark conf
        fallbackDns = [ "162.252.172.57" "149.154.159.92" ];
      };

      # From surfshark conf
      networking = {
        useHostResolvConf = false;

        wireguard.interfaces."tun" = {
          ips = [ "10.14.0.2/16" ];

          peers = [{
            publicKey = "m+L7BVQWDwU2TxjfspMRLkRctvmo7fOkd+eVk6KC5lM=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "45.149.173.234:51820";
          }];
        };

        nat = {
          enable = true;
          enableIPv6 = true;
        };
      };

      services.getty.autologinUser = "root";
    };
  };
}
