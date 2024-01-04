inputs:
{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix
    "${inputs.nixos-hardware}/common/cpu/amd"
    inputs.self.nixosModules.pc
  ];

  time.timeZone = "US/Pacific";

  astral.tailscale.oneOffKey =
    "tskey-auth-kCDetm2CNTRL-3bYunP5bKyUL7q7gdE9DxUHjinjQuZPZ";
  astral.vfio = {
    enable = true;
    iommu-mode = "amd_iommu";
    pci-devs = [ ];
  };

  # so i can be a *gamer*
  programs.steam.enable = true;

  virtualisation.lxd.enable = true;

  services.xserver = {
    displayManager = {
      startx.enable = false;
      lightdm.enable = true;
    };
    desktopManager.xfce.enable = true;
  };

  # AMD Starship/Matisse Audio is broken on pipewire, maybe this fixes?
  services.pipewire.enable = mkForce false;
  hardware.pulseaudio.enable = mkForce true;

  services.blueman.enable = true;

  networking = {
    hostName = "chungus";

    hostId = "b75842a7";
    networkmanager.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_6;

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
          GRUB_TERMINAL=console
        '';
        # TODO pick a grub background
        # splashImage = ./banana-grub-bg-dark.jpg;
      };
    };
  };

  # RGB stuff
  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [ openrgb win10hotplug ];

  services.xserver.dpi = 224;
}

