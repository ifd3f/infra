# Microsoft surface specific tweaks
{
  inputs,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc-ssd
    microsoft-surface-common
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
