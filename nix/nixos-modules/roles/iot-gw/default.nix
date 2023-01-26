# IoT Gateway, running at home.
{ config, pkgs, lib, ... }:
let
  vs = config.vault-secrets.secrets.iot-gw-s02;

  zigbeeDongle =
    "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_6aa3627f3e98ec119bbbaad044d80d13-if00-port0";

in with lib; {
  # vault kv put kv/iot-gw-s02/environment \
  #   ZIGBEE2MQTT_CONFIG_MQTT_USER=@ \
  #   ZIGBEE2MQTT_CONFIG_MQTT_PASSWORD=@
  vault-secrets.secrets.iot-gw-s02 = { };

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
      permit_join = false;
      frontend = {
        host = "0.0.0.0";
        port = 38323;
        url = "https://zigbee2mqtt.in.astrid.tech";
      };

      mqtt = {
        base_topic = "zigbee2mqtt-s02";
        client_id = "ghoti-zigbee2mqtt";
        user = "zigbee2mqtt";
        password = "we are connecting over localhost so this is always trusted";
        server = "mqtt://localhost:1883";

        force_disable_retain = false;
        include_device_information = true;
        keepalive = 60;
        reject_unauthorized = true;
        version = 4;
      };
    };
  };

  # Local mosquitto instance to store-and-forward data to the global broker.
  services.mosquitto = {
    enable = true;

    listeners = [
      # Trust connections on localhost
      {
        users.zigbee2mqtt.password =
          config.services.zigbee2mqtt.settings.mqtt.password;

        # omitPasswordAuth = true;
        address = "::1";
        port = 1883;
      }
    ];
  };

  services.nginx.virtualHosts = {
    "ha.s02.astrid.tech" = {
      locations."/".proxyPass = "http://localhost:8123";
    };

    "zigbee2mqtt.s02.astrid.tech" = {
      locations."/".proxyPass = let z2m = config.services.zigbee2mqtt;
      in "http://localhost:${toString z2m.settings.frontend.port}";
    };
  };
}
