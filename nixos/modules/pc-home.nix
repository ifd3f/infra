# Setup the /home directory for personal computers.
{ pkgs, lib, config, ... }:
let cfg = config.ext4-ephroot;
in
{
  # Bind mount home to persistence directory
  systemd.services."ensure-home-state" = {
    description = "Ensure directory for /home state exists";
    script = ''
      mkdir -p /persist/home
    '';
    wantedBy = [ "home.mount" ];
    serviceConfig = {
      Type = "oneshot";
    };
  };
  fileSystems."/home" = {
    device = "/persist/home";
    options = [ "bind" ];
  };

  systemd.services."ensure-shadow" = {
    description = "Ensure shadow file exists";
    script = ''
      touch /persist/etc/shadow
    '';
    wantedBy = [ "etc-shadow.mount" ];
    serviceConfig = {
      Type = "oneshot";
    };
  };
  fileSystems."/etc/shadow" = {
    device = "/persist/etc/shadow";
    options = [ "bind" ];
  };
}
