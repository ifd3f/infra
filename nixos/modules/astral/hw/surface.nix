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

  config = let cfg = config.astral.hw.surface;
  in {
    environment.systemPackages = with pkgs; [
      iptsd
      onboard
      surface-control
      xinput_calibrator
    ];

    services.touchegg.enable = true;

    services.xserver.libinput = { enable = true; };

    # https://github.com/linux-surface/iptsd/blob/master/etc/ipts.conf
    environment.etc."ipts.conf".text = ''
      [Config]
      BlockOnPalm = true
      TouchThreshold = 20
      StabilityThreshold = 0.1
    '';
  };
}
