{ config, ... }:
{
  services.deluge = {
    enable = true;
    web.enable = true;
  };

  networking.firewall.allowedTCPPorts = [ config.services.deluge.web.port ];

  fileSystems."/var/lib/deluge" = {
    device = "dpool/torrent";
    fsType = "zfs";
  };

  systemd.services.deluged = {
    requires = [ "var-lib-deluge.mount" ];
    after = [ "var-lib-deluge.mount" ];
  };

  users.groups."deluge".members = [ "astrid" ];
}
