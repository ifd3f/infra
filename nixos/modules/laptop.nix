# A role representing a laptop.
{ self, ... }:
{ lib, pkgs, ... }: {
  time.timeZone = "US/Pacific";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.xorg.xf86videointel
    pkgs.xorg.xf86inputsynaptics
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
