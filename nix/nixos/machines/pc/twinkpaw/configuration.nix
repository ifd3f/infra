{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
{
  imports = [
    ./hardware-configuration.nix
    "${inputs.nixos-hardware}/common/cpu/amd"
    "${inputs.self}/nix/nixos/modules/roles/pc"
  ];

  time.timeZone = "US/Pacific";

  services.xserver.dpi = 209;

  networking = {
    hostName = "twinkpaw";
    hostId = "76d4a2bc";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = false;
      splashImage = inputs.self.helpers.${pkgs.system}.adjustImageBrightness "twinkpaw-bg" (-10) ./bg.jpg;
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
