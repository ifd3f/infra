# Home media server, hooked up directly to the TV.
{ config, pkgs, lib, ... }:
let vs = config.vault-secrets.secrets.media-server;
in with lib; {
  # vault kv put kv/media-server/secrets ovpn_conf=@ ovpn_userpass=@
  #  - ovpn_conf: the full config file provided by surfshark
  #  - ovpn_userpass: a string of USERNAME <newline> PASSWORD
  vault-secrets.secrets."media-server" = {
    group = "root";
    services = mkForce [ "openvpn-surfshark.service" ];
  };

  services.nginx.virtualHosts."deluge.s02.astrid.tech" = {
    locations."/".proxyPass =
      "http://localhost:${toString config.services.deluge.web.port}";
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

  systemd.services.deluged-watchdog = {
    description = "Watchdog for deluged";

    bindsTo = [ "deluged.service" ];
    requiredBy = [ "deluged.service" ];

    path = with pkgs; [ coreutils deluge systemd ];
    script = ''
      set -euxo pipefail

      systemd-notify --ready

      while true; do
        deluge console status  
        systemd-notify WATCHDOG=1
        sleep 10
      done
    '';

    serviceConfig = {
      User = "deluge";

      WatchdogSec = 20;
      Restart = "on-failure";
      NotifyAccess = "all";
    };
  };

  users.users.tv = {
    group = "users";
    extraGroups = [ "deluge" ];
    isNormalUser = true;
  };

  services.openvpn.servers.surfshark = {
    config = ''
      config ${vs}/ovpn_conf
      auth-user-pass ${vs}/ovpn_userpass
    '';
  };

  services.resolved = {
    enable = true;
    # From surfshark conf
    fallbackDns = [ "162.252.172.57" "149.154.159.92" ];
  };

  environment.systemPackages = with pkgs; [ tcpdump ];
}
