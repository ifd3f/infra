# Octoprint, a camera, and webserver, 3-for-1 deal!
{ self, ... }:
{ config, pkgs, lib, ... }: {
  imports = with self.nixosModules; [ sshd ];

  options.services.octoprint-full = with lib; {
    host = mkOption {
      type = types.str;
      description = "The host to serve our full suite on";
    };

    cameraPort = mkOption {
      type = types.port;
      description = "The port to run the camera server on";
      default = 34781;
    };

    octoprintPort = mkOption {
      type = types.port;
      description = "The port to run octoprint on";
      default = 62933;
    };
  };

  # Allow http(s) traffic
  config.networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  config.services = let cfg = config.services.octoprint-full;
  in {
    caddy = {
      enable = true;
      virtualHosts."${cfg.host}".extraConfig = ''
        route /webcam {
          rewrite * /
          reverse_proxy http://localhost:${toString cfg.cameraPort}
        }

        route * {
          reverse_proxy * http://localhost:${toString cfg.octoprintPort}
        }

        tls self_signed
        encode zstd gzip
      '';
    };

    octoprint = {
      enable = true;
      port = cfg.octoprintPort;
      extraConfig.webcam = {
        stream = "http://${cfg.host}/webcam?action=stream";
        snapshot = "http://${cfg.host}/webcam?action=snapshot";
      };
    };

    mjpg-streamer = {
      enable = true;
      inputPlugin = "input_uvc.so";
      outputPlugin = "output_http.so -w @www@ -n -p ${toString cfg.cameraPort}";
    };
  };
}
