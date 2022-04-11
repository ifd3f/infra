{ nixos-hardware }:
{ config, lib, pkgs, ... }:
with lib; {
  options.astral.hw.surface.enable = mkOption {
    description = ''
      Enable standard Surface Pro configs

      Also see https://github.com/NixOS/nixos-hardware/tree/master/microsoft/surface
    '';
    default = false;
    type = types.bool;
  };

  config = let cfg = config.astral.hw.surface; in {
    environment.systemPackages = with pkgs; [
      iptsd
      onboard
      surface-control
    ];

    services.touchegg.enable = true;

    services.xserver.libinput = {
      enable = true;
    };
  };
}
