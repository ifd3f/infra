# Contabo VPS.
{ pkgs, lib, inputs, ... }: {
  imports = [
    inputs.self.nixosModules.contabo-vps
    inputs.self.nixosModules.server

    inputs.self.nixosModules.akkoma
    inputs.self.nixosModules.armqr
    inputs.self.nixosModules.auth-dns
    inputs.self.nixosModules.piwigo
  ];

  astral = {
    ci.deploy-to = "173.212.242.107";
  };

  networking = {
    hostName = "diluc";
    domain = "h.astrid.tech";

    firewall.allowedTCPPorts = [ 80 443 ];
    interfaces.ens18.ipv6.addresses = [{
      address = "2a02:c207:2087:999::1";
      prefixLength = 128;
    }];

    bridges.bripa.interfaces = [ ];
    interfaces.bripa.ipv6.addresses = [{
      address = "2a02:c207:2087:999:1::1";
      prefixLength = 112;
    }];
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

  virtualisation.lxc.enable = true;
  virtualisation.lxd.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ab29083b-5158-43d2-ab40-e3b40437bf31";
    fsType = "ext4";
  };
}
