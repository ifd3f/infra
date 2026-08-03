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

  astral = {
    sshd.enable = true;
    zfs-utils.enable = true;
  };

  programs.sway.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  time.timeZone = "US/Pacific";

  system.stateVersion = "25.05";
  
  # TODO: get rid of it when done deving
  nix.settings.require-sigs = false;
}
