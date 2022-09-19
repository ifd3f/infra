# My gaming desktop.
let
  gpuBig = "6"; # RTX 3070 Ti
  gpuBigVGAID = "10de:2482";
  gpuBigAudioID = "10de:228b";

  gpuSmall = "4"; # GTX 750 Ti
in { pkgs, lib, config, ... }: {
  imports = [ ./hardware-configuration.nix ];

  time.timeZone = "US/Pacific";

  astral = { roles.pc.enable = true; };

  # so i can be a *gamer*
  programs.steam.enable = true;

  virtualisation.lxd.enable = true;

  # Nvidia configs, following this page https://nixos.wiki/wiki/Nvidia
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.startx.enable = true;
    displayManager.lightdm.enable = lib.mkForce false;
  };

  hardware.opengl.enable = true;
  #hardware.nvidia = {
  #  modesetting.enable = true;
  #  prime = {
  #    offload.enable = true;

  #    nvidiaBusId = "PCI:${gpuBig}:0:0";
  #    amdgpuBusId = "PCI:${gpuSmall}:0:0";
  #  };
  #  powerManagement.enable = true;
  #};

  services.blueman.enable = true;

  networking = {
    hostName = "chungus";
    domain = "id.astrid.tech";

    hostId = "b75842a7";
    networkmanager.enable = true;
    useDHCP = false;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [
      # enable IOMMU
      "amd_iommu=on"
      "video=HDMI-0:3840x2160me"
      "video=HDMI-1:2560x1440me"

      # isolate the GPU
      "vfio-pci.ids=${gpuBigVGAID},${gpuBigAudioID}"
    ];

    initrd.kernelModules =
      [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];

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
}

