{
  config,
  pkgs,
  lib,
  self,
  nixos-hardware,
  ...
}:
with lib;
{
  _class = "nixos";
  nixpkgs.system = "x86_64-linux";
  networking = {
    hostName = "twinkpaw";
    hostId = "76d4a2bc";
  };

  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-cpu-amd
  ];

  time.timeZone = "US/Pacific";

  services.xserver.dpi = 209;

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = false;
      splashImage = pkgs.astral.helpers.adjustImageBrightness "twinkpaw-bg" (-10) ./bg.jpg;
    };
  };

  environment.systemPackages = with pkgs; [
    # Screen has a problem of blanking randomly. I don't know why it does this,
    # but either way, this is a script that does the necessary unfucking procedure.
    (writeShellScriptBin "ufsc" ''
      xrandr --output eDP-1 --off && xrandr --output eDP-1 --auto
    '')
  ];

  system.stateVersion = "25.05";
}
