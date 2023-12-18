{ pkgs, lib, config, ... }:
with lib;
let cfg = config.astral.monitoring-node;
in {
  config = mkIf cfg.enable {
    astral.acme.enable = mkIf (cfg.scrapeTransport == "https") true;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };

    services.nginx = {
      enable = true;
      statusPage = true;

      virtualHosts."${cfg.vhost}" = mkMerge [
        (mkIf (cfg.scrapeTransport == "https") {
          enableACME = true;
          forceSSL = true;

          # TODO: figure out mTLS
          extraConfig = ''
            # durin
            allow 192.9.241.223;

            # amiya
            allow 208.87.130.175;

            allow 127.0.0.1;
            allow ::1;

            deny all;
          '';
        })

        (mkIf (cfg.scrapeTransport == "tailscale") {
          # TODO: figure out tail auth?
          extraConfig = ''
            # durin
            allow 100.91.90.4;
            allow fd7a:115c:a1e0:ab12:4843:cd96:625b:5a04;

            # amiya
            allow 100.117.107.85;
            allow fd7a:115c:a1e0:ab12:4843:cd96:6275:6b55;

            allow 127.0.0.1;
            allow ::1;

            deny all;
          '';
        })
      ];
    };
  };
}
