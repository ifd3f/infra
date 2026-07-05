{
  nixos-hardware,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.microsoft-surface-common
  ];

  hardware.microsoft-surface.kernelVersion = "stable";
  services.iptsd = {
    enable = true;
    config = {
      Config = {
        BlockOnPalm = true;
        TouchThreshold = 20;
        StabilityThreshold = 0.1;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    iptsd
    onboard
    surface-control
    xinput_calibrator
  ];

  services.touchegg.enable = true;
  services.libinput.enable = true;
}
