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

  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.dpi = 224;

  # specialisation."VFIO".configuration = {
  #   system.nixos.tags = [ "with-vfio" ];
  #   astral.vfio.enable = mkForce true;
  # };

  system.stateVersion = "25.05";
}
