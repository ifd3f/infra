# Since Keycloak seems to really hate LDAP over IPv6, we'll use Jool
# (https://www.jool.mx/en/) to set up a SIIT translation thing as a
# little shim between Keycloak and our LDAP server.

{ config, pkgs, ... }:
let
  instance_name = "kc-ldap-shim";
  shim_ipv4 = "127.46.3.89";
  ldap_ipv6 = "2a02:c207:2087:999:1::2";
in {
  networking.hosts.${shim_ipv4} = [ "ldap-shim" ];

  boot = {
    kernelModules = [ "jool" "jool_siit" ];
    extraModulePackages = with config.boot.kernelPackages; [ jool ];
  };

  systemd.services.kc-ldap-shim = let
    shim-config = pkgs.writeText "kc-ldap-shim.json" (builtins.toJSON {
      instance = instance_name;
      framework = "netfilter";
      eamt = [{
        "ipv4 prefix" = "${shim_ipv4}/32";
        "ipv6 prefix" = "${ldap_ipv6}/128";
      }];
    });

    jool_siit = "${pkgs.jool-cli}/bin/jool_siit";
  in {
    description = "SIIT shim between Keycloak (IPv4) and Central LDAP (IPv6)";
    wantedBy = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = "${jool_siit} -i ${instance_name} file handle ${shim-config}";
      ExecStop = "${jool_siit} instance remove ${instance_name}";
    };
  };

  # systemd.services.keycloak.wants = [ "setup-kc-ldap-shim.service" ];
}
