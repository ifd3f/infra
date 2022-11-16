# Contabo VPS.
{ pkgs, lib, inputs, ... }: {
  imports = [ inputs.self.nixosModules.contabo-vps ];

  astral = {
    ci.deploy-to = "173.212.242.107";

    acme.enable = true;
    roles = {
      akkoma.enable = true;
      armqr.enable = true;
      auth-dns.enable = true;
      monitoring.center.enable = true;
      monitoring.node.enable = true;
      piwigo.enable = true;
      sso-provider.enable = false;

      server.enable = true;
    };
  };

  networking.hostName = "diluc";
  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
}
