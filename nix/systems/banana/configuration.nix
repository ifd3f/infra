# My gaming laptop.
{ pkgs, lib, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.pc
    inputs.self.nixosModules.laptop
  ];

  time.timeZone = "US/Pacific";

  astral.vfio = {
    enable = true;
    iommu-mode = "intel_iommu";
    pci-devs = [ ];
  };

  # so i can be a *gamer*
  programs.steam.enable = true;

  # Nvidia configs, following this page https://nixos.wiki/wiki/Nvidia
  services = {
    xserver.videoDrivers = [ "nvidia" ];
    blueman.enable = true;
  };

  virtualisation.lxd.enable = true;

  hardware = {
    opengl.enable = true;

    nvidia.prime = {
      offload.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };

    bluetooth.enable = true;
  };

  networking = {
    hostName = "banana";

    hostId = "76d4a2bc";
    networkmanager.enable = true;
    useDHCP = false;
  };

  boot = {
    # rtw_8822be issue? https://bbs.archlinux.org/viewtopic.php?id=260589
    kernelParams = [ "pcie_aspm.policy=powersave" ];
    kernelPackages = pkgs.linuxPackages;

    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        version = 2;
        useOSProber = true;
        splashImage = ./banana-grub-bg-dark.jpg;
      };
    };
  };

  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    astral.vfio.pci-devs = lib.mkForce [
      "10de:1c20" # Graphics
      "10de:10f1" # Audio
    ];
  };

  # Windows drive
  fileSystems."/dos/c" = {
    device = "/dev/disk/by-uuid/908CEA3C8CEA1D0A";
    fsType = "ntfs";
    options = [ "rw" ];
  };
}

