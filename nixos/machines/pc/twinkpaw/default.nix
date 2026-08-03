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
  imports = [
    nixos-hardware.nixosModules.common-cpu-intel

    ./boot.nix
    ./fs.nix
  ];

  _class = "nixos";
  nixpkgs.system = "x86_64-linux";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking = {
    hostName = "twinkpaw";
    hostId = "76d4a2bc";
  };

  astral.roles.pc.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  time.timeZone = "US/Pacific";

  services.xserver.dpi = 209;

  environment.systemPackages = with pkgs; [
    # Screen has a problem of blanking randomly. I don't know why it does this,
    # but either way, this is a script that does the necessary unfucking procedure.
    (writeShellScriptBin "ufsc" ''
      xrandr --output eDP-1 --off && xrandr --output eDP-1 --auto
    '')
  ];

  system.stateVersion = "25.05";
}
