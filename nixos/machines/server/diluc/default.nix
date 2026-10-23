{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  _class = "nixos";
  nixpkgs.system = "x86_64-linux";

  astral = {
    roles.server.enable = true;
    roles.contabo-vps.enable = true;
    roles.auth-dns.enable = true;
    acme.enable = true;
  };

  # Logrotate config build fail workaround
  # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  services.logrotate.checkConfig = false;

  networking = {
    hostName = "diluc";
    hostId = "6c14799c";
    domain = "h.astrid.tech";

    firewall.allowedTCPPorts = [
      80
      443
    ];
    interfaces.ens18.ipv6.addresses = [
      {
        address = "2a02:c207:2087:999::1";
        prefixLength = 128;
      }
    ];
  };

  time.timeZone = "Europe/Berlin";

  services.nginx = {
    enable = true;

    clientMaxBodySize = "16m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };

  virtualisation.vmVariant = {
    virtualisation.forwardPorts = [
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
      {
        from = "host";
        guest.port = 443;
        host.port = 8443;
      }
      {
        from = "host";
        proto = "udp";
        guest.port = 53;
        host.port = 8053;
      }
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ab29083b-5158-43d2-ab40-e3b40437bf31";
    fsType = "ext4";
  };

  services.nginx.virtualHosts."diluc.h.astrid.tech" = {
    enableACME = true;

    # Files are to be sticked into /var/www/diluc.h.astrid.tech/files.
    locations."/files" = {
      root = "/var/www/diluc.h.astrid.tech";
      extraConfig = ''
        autoindex on;
        allow all;
      '';
    };
  };

  services.armqr = {
    enable = true;
    port = 64723;
    nginx.enable = true;
    nginx.fqdns = [
      "0q4.org"
      "qr.arm.astridyu.com"
    ];
  };

  system.stateVersion = "26.05";
}
