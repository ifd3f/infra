{ config, ... }: {
  services.deluge = {
    enable = true;
    web.enable = true;
  };

  networking.firewall.allowedTCPPorts = [ config.services.deluge.web.port ];

  users.groups."deluge".members = [ "astrid" ];
}
