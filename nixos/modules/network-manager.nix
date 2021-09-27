{
  systemd.services."ensure-network-manager-state" = {
    description = "Ensure directory for NetworkManager state exists";
    script = ''
      mkdir -p /persist/etc/NetworkManager
    '';
    wantedBy = [ "etc-networkmanager.mount" ];
    serviceConfig = {
      Type = "oneshot";
    };
  };
  fileSystems."/etc/NetworkManager" = {
    device = "/persist/etc/NetworkManager";
    options = [ "bind" ];
  };
}