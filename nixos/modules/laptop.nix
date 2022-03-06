# A role representing a laptop.
{ self, ... }:
{ lib, pkgs, ... }: {
  environment.systemPackages = [
    pkgs.xorg.xf86videointel
    pkgs.xorg.xf86inputsynaptics
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
