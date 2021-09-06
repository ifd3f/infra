# Base configs for bare-metal servers.

{ pkgs, ... }:
{
  systemd.services."update-nixos-config" = {
    description = "Update NixOS config";
    script = ''
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake github:astralbijection/infrastructure/main --refresh
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  systemd.timers."update-nixos-config" = {
    description = "Update NixOS config daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 4:00:00";
      Persistent = "true";
    };
  };
}
