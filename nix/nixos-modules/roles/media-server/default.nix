# Home media server, hooked up directly to the TV.
{ config, pkgs, lib, ... }:
let vs = config.vault-secrets.secrets.media-server;
in with lib; {
  # vault kv put kv/media-server/secrets ovpn_conf=@ ovpn_userpass=@
  #  - ovpn_conf: the config provided by surfshark
  #  - ovpn_userpass: a string of USERNAME <newline> PASSWORD
  vault-secrets.secrets."media-server" = { };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.ip_forward" = 1;
  };

  services.nginx.virtualHosts."deluge.s02.astrid.tech" = {
    locations."/".proxyPass = let container = config.containers.deluge;
    in "http://${container.localAddress}"
    + ":${toString container.config.services.deluge.web.port}";
  };

  services.xserver = {
    enable = true;
    desktopManager.kodi.enable = true;
  };

  systemd.services.media-server-secrets = {
    requiredBy = [ "container@surfshark.service" ];
    before = [ "container@surfshark.service" ];
  };

  networking = {
    nat = {
      enable = true;
      enableIPv6 = true;
      internalInterfaces = [ "br-torrent" ];
    };

    bridges."br-torrent".interfaces = [ ];
    interfaces."br-torrent" = {
      ipv4.addresses = [{
        address = "10.16.50.1";
        prefixLength = 24;
      }];
      ipv6.addresses = [{
        address = "fc00::1";
        prefixLength = 24;
      }];
    };
  };

  containers.deluge = {
    autoStart = true;
    privateNetwork = true;

    hostBridge = "br-torrent";
    localAddress = "10.16.50.2/24";
    localAddress6 = "fc00::2/64";

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

        # Point to the VPN
        defaultGateway.address = "10.16.50.3";
        defaultGateway6.address = "fc00::3";

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
    enableTun = true;

    hostBridge = "br-torrent";
    localAddress = "10.16.50.3/24";
    localAddress6 = "fc00::3/64";

    bindMounts = {
      "${vs}" = {
        hostPath = "${vs}";
        isReadOnly = true;
      };
    };

    config = { config, pkgs, ... }: {
      system.stateVersion = "22.05";

      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

      services.openvpn.servers.surfshark = {
        config = ''
          auth-user-pass ${vs}/ovpn_userpass
          config ${vs}/ovpn_conf
        '';
      };

      services.resolved = {
        enable = true;
        # From surfshark conf
        fallbackDns = [ "162.252.172.57" "149.154.159.92" ];
      };

      networking = {
        useHostResolvConf = false;

        # Point to the host
        defaultGateway.address = "10.16.50.1";
        defaultGateway6.address = "fc00::1";

        nat = {
          enable = true;
          enableIPv6 = true;
          internalInterfaces = [ "eth0" ];
        };
      };

      services.getty.autologinUser = "root";
    };
  };
}
