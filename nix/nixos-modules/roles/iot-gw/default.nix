# IoT Gateway, running at home.
{ config, pkgs, lib, ... }:
let
  zigbeeDongle =
    "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_6aa3627f3e98ec119bbbaad044d80d13-if00-port0";

in with lib; {
  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = config.time.timeZone;
      ports = [ "8123" ];
      image = "ghcr.io/home-assistant/home-assistant:stable";
    };
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      serial.port = zigbeeDongle;
      network_key = "!/var/lib/secrets/z2m.yml network_key";
      frontend = {
        host = "0.0.0.0";
        port = 38323;
        url = "https://zigbee2mqtt.in.astrid.tech";
      };

      mqtt = {
        base_topic = "zigbee2mqtt-s02";
        client_id = "ghoti-zigbee2mqtt";
        server = "mqtt://localhost:1883";

        cert = "/etc/ssl/mqtt-client.crt";
        key = "/etc/ssl/mqtt-client.key";

        force_disable_retain = false;
        include_device_information = true;
        keepalive = 60;
        reject_unauthorized = true;
        version = 4;
      };
    };
  };

  services.nginx.virtualHosts = {
    "ha.in.astrid.tech" = {
      locations."/".proxyPass = "http://localhost:8123";
    };

    "zigbee2mqtt.in.astrid.tech" = {
      locations."/".proxyPass = let z2m = config.services.zigbee2mqtt;
      in "http://localhost:${toString z2m.settings.frontend.port}";
    };
  };
}
