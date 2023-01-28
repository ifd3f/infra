# Home media server, hooked up directly to the TV.
{ config, pkgs, lib, ... }:
let
  vs = config.vault-secrets.secrets.media-server;
in with lib; {
  # vault kv put kv/media-server/secrets ovpn_conf=@ ovpn_userpass=@
  #  - ovpn_conf: the full config file provided by surfshark
  #  - ovpn_userpass: a string of USERNAME <newline> PASSWORD
  vault-secrets.secrets."media-server" = {
    group = "root";
    services = mkForce [ "container@torrentserv.service" ];
  };

  services.nginx.virtualHosts."deluge.s02.astrid.tech" = {
    locations."/".proxyPass =
      "http://localhost:${toString config.services.deluge.web.port}";
  };

  services.nginx.virtualHosts."transmission.s02.astrid.tech" = {
    locations."/" = {
      proxyPass = "http://localhost:" + toString
        config.containers.torrentserv.config.services.transmission.settings.rpc-port;
      proxyWebsockets = true;
    };
  };

  services.xserver = {
    enable = true;

    displayManager.autoLogin = {
      enable = true;
      user = "tv";
    };

    desktopManager.kodi.enable = true;
  };

  systemd.services.media-server-secrets = {
    requiredBy = [ "openvpn-surfshark.service" ];
    before = [ "openvpn-surfshark.service" ];
  };

  services.deluge = {
    enable = true;
    web.enable = true;
  };

  users.users.tv = {
    group = "users";
    extraGroups = [ "deluge" "transmission" ];
    isNormalUser = true;
  };

  environment.systemPackages = with pkgs; [ tcpdump ];

  containers.torrentserv = {
    autoStart = true;
    ephemeral = true;
    enableTun = true;

    bindMounts."${vs}" = {
      hostPath = "${vs}";
      mountPoint = "/secrets";
      isReadOnly = true;
    };

    bindMounts."${config.containers.torrentserv.config.services.transmission.home}" =
      {
        hostPath = "/srv/transmission";
        isReadOnly = false;
      };

    config = { config, pkgs, ... }: {
      system.stateVersion = "23.05";

      services.transmission.enable = true;

      services.openvpn.servers.surfshark = {
        config = ''
          config /secrets/ovpn_conf
          auth-user-pass /secrets/ovpn_userpass
        '';
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
      };

      services.getty.autologinUser = "root";

      environment.systemPackages = with pkgs; [ tcpdump ];
    };
  };
}
