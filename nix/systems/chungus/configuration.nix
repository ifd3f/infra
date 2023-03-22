# My gaming desktop.
{ pkgs, lib, config, inputs, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix
    ./x11.nix
    "${inputs.nixos-hardware}/common/cpu/amd"
    inputs.self.nixosModules.pc
  ];

  time.timeZone = "US/Pacific";

  astral.tailscale.enable = mkForce false;
  astral.vfio = {
    enable = true;
    iommu-mode = "amd_iommu";
    pci-devs = [ ];
  };

  # so i can be a *gamer*
  programs.steam.enable = true;

  virtualisation.lxd.enable = true;

  # Nvidia configs, following this page https://nixos.wiki/wiki/Nvidia
  services.xserver.displayManager = {
    startx.enable = true;
    lightdm.enable = lib.mkForce false;
  };

  services.blueman.enable = true;

  networking = {
    hostName = "chungus";

    hostId = "b75842a7";
    networkmanager.enable = true;

    # Primary internet connection with a bridge
    bridges.br0.interfaces = [ "enp5s0" ];
    interfaces.enp5s0.useDHCP = true;
    interfaces.br0.useDHCP = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;

    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        gfxmodeEfi = "auto";
        gfxpayloadEfi = "keep";
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        version = 2;
        useOSProber = true;
        extraConfig = ''
          GRUB_TERMINAL=console
        '';
        # TODO pick a grub background
        # splashImage = ./banana-grub-bg-dark.jpg;
      };
    };
  };

  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    astral.vfio.pci-devs = lib.mkForce [
      "10de:2482" # Graphics
      "10de:228b" # Audio
    ];
  };

  # RGB stuff
  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [ openrgb win10hotplug ];

  services.xserver.dpi = 224;
}

