inputs:
let
  rolepaths = {
    contabo-vps = ./roles/contabo-vps.nix;
    laptop = ./roles/laptop.nix;
    oracle-cloud-vps = ./roles/oracle-cloud-vps.nix;
    pc = ./roles/pc.nix;
    server = ./roles/server.nix;

    akkoma = ./roles/akkoma;
    armqr = ./roles/armqr.nix;
    auth-dns = ./roles/auth-dns;
    ejabberd = ./roles/ejabberd.nix;
    iot-gw = ./roles/iot-gw;
    loki-server = ./roles/loki-server.nix;
    media-server = ./roles/media-server;
    monitoring-center = ./roles/monitoring-center;
    nextcloud = ./roles/nextcloud.nix;
    octoprint = ./roles/octoprint.nix;
    piwigo = ./roles/piwigo;
    sso-provider = ./roles/sso-provider;
    vault = ./roles/vault;
  };

in builtins.mapAttrs (_: p: import p inputs) rolepaths
