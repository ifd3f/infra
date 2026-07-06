{
  config,
  pkgs,
  lib,
  nixos-hardware,
  ...
}:
with lib;
{
  _class = "nixos";
  nixpkgs.system = "x86_64-linux";
  networking = {
    hostName = "chungus";
    hostId = "b75842a7";
  };

  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-cpu-amd
  ];

  astral.roles.pc.enable = true;
  astral.peripherals.rgb.enable = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "US/Pacific";

  # because they dropped support for P620 >.>
  hardware.nvidia.open = false;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.dpi = 224;

  system.stateVersion = "25.05";
}
