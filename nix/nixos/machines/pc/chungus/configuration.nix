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

  programs.steam.enable = true;

  virtualisation.lxd.enable = true;

  services.pipewire = {
    enable = mkForce true;
    jack.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;

  networking = {
    hostName = "chungus";

    hostId = "b75842a7";
    networkmanager.enable = true;
  };

  boot = {
    loader = {
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
  };

  # RGB stuff
  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [ openrgb ];

  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.dpi = 224;

  # specialisation."VFIO".configuration = {
  #   system.nixos.tags = [ "with-vfio" ];
  #   astral.vfio.enable = mkForce true;
  # };

  system.stateVersion = "25.05";
}
