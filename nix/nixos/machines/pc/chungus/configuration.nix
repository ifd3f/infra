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
  ];

  astral.roles.pc.enable = true;
  astral.peripherals.rgb.enable = true;
  astral.zfs-utils.enable = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "chungus";
    hostId = "b75842a7";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      gfxmodeEfi = "auto";
      gfxpayloadEfi = "keep";
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
      extraConfig = ''
        GRUB_TERMINAL=gfxterm
        GRUB_GFXMODE=640x480
      '';
      # TODO pick a grub background
      # splashImage = ./banana-grub-bg-dark.jpg;
    };
  };

  # because they dropped support for P620 >.>
  hardware.nvidia.open = false;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.dpi = 224;

  # specialisation."VFIO".configuration = {
  #   system.nixos.tags = [ "with-vfio" ];
  #   astral.vfio.enable = mkForce true;
  # };

  environment.systemPackages = with pkgs; [
    (
      (import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.cudaSupport = true;
      }).llama-cpp.overrideAttrs
      { enableParallelBuilding = true; }
    )
  ];

  system.stateVersion = "25.05";
}
