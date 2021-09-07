# Updates the system from this flake every day.

{ pkgs, ... }:
{
  # Note that this script forks so that it doesn't accidentally cancel itself.
  # TODO: is there a better way? 
  systemd.services."update-nixos-config" = {
    description = "Update NixOS config";
    script = ''
      /run/current-system/sw/bin/nixos-rebuild switch --flake github:astralbijection/infrastructure/main --refresh &
    '';
    serviceConfig = {
      Type = "forking";
    };
  };

  # Systemd will run this service every day.
  systemd.timers."update-nixos-config" = {
    description = "Update NixOS config daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 4:00:00";
      Persistent = "true";
    };
  };
}
