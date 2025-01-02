inputs:
{ config, pkgs, lib, ... }:
let
  mkGpu = { video, audio }: {
    inherit video audio;
    pciDevs = [ video audio ];
  };
  mainGpu = mkGpu {
    video = "10de:2482";
    audio = "10de:228b";
  };
  backupGpu = mkGpu {
    video = "10de:1cb6";
    audio = "10de:0fb9";
  };
in with lib; {
  imports = [
    ./hardware-configuration.nix
    "${inputs.nixos-hardware}/common/cpu/amd"
    inputs.self.nixosModules.pc
  ];

  time.timeZone = "US/Pacific";

  astral.tailscale.oneOffKey =
    "tskey-auth-kCDetm2CNTRL-3bYunP5bKyUL7q7gdE9DxUHjinjQuZPZ";
  astral.vfio = {
    enable = false;
    iommu-mode = "amd_iommu";
    gpuIds = mainGpu.pciDevs;
    vfiohotplugConfig = {
      connection = "qemu:///system";
      dom = "win10";
      groups = {
        gpu = [
          {
            type = "pci";
            id = mainGpu.audio;
          }
          {
            type = "pci";
            id = mainGpu.video;
          }
        ];
        keyboard = [{
          type = "usb";
          id = "3297:4976";
        }];
        mouse = [{
          type = "usb";
          id = "046d:c08a";
        }];
        usbcontroller = [{
          type = "pci";
          id = "1022:149c";
        }];
      };
    };
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

  services.pipewire = {
    enable = mkForce true;
    jack.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
  };
  # hardware.pulseaudio.enable = mkForce true;

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

  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    astral.vfio.enable = mkForce true;
  };
}

