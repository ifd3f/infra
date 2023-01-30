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
      extraOptions = [ "--network=host" ];
      image = "ghcr.io/home-assistant/home-assistant:stable";
    };
  };

  networking.firewall.allowedTCPPorts = [ 1883 8883 ];

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      serial.port = zigbeeDongle;
      permit_join = false;
      frontend = {
        host = "0.0.0.0";
        port = 38323;
        url = "https://zigbee2mqtt.s02.astrid.tech";
      };

      mqtt = {
        base_topic = "s02/zigbee2mqtt";
        client_id = "ghoti-zigbee2mqtt";
        user = "zigbee2mqtt";
        password = "password";
        server = "mqtt://localhost:1883";

        force_disable_retain = false;
        include_device_information = true;
        keepalive = 60;
        reject_unauthorized = true;
        version = 4;
      };

      homeassistant = {
        discovery_topic = "s02/homeassistant";
        legacy_entity_attributes = true;
        legacy_triggers = true;
        status_topic = "s02/hass/status";
      };
    };
  };

  # Local mosquitto instance to store-and-forward data to the global broker.
  services.mosquitto = {
    enable = true;

    listeners = [
      # We trust connections from localhost, so the passwords are quite lax and in cleartext.
      {
        users.zigbee2mqtt = {
          acl =
            [ "readwrite s02/homeassistant/#" "readwrite s02/zigbee2mqtt/#" ];
          password = config.services.zigbee2mqtt.settings.mqtt.password;
        };

        users.has02 = {
          acl = [ "readwrite #" ];
          password = "password";
        };

        address = "::1";
        port = 1883;
      }

      {
        users.astrid = {
          acl = [ "readwrite #" ];
          passwordFile = "${config.services.mosquitto.dataDir}/astridpassword";
        };

        address = "192.168.50.235";
        port = 1883;
      }
    ];
  };

  services.nginx.virtualHosts = {
    "ha.s02.astrid.tech" = {
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://localhost:8123";
      };
    };

    "zigbee2mqtt.s02.astrid.tech" = {
      locations."/" = let z2m = config.services.zigbee2mqtt;
      in {
        proxyWebsockets = true;
        proxyPass = "http://localhost:${toString z2m.settings.frontend.port}";
      };
    };
  };
}
