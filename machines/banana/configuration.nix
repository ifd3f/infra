inputs:
{ config, pkgs, lib, ... }:
with lib; {
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

  astral.tailscale.oneOffKey =
    "tskey-auth-kQpYuB2CNTRL-krpVu4TaHhBfxV7SWg3LgBtPG8t3QKyh4";

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
      # This machine will mostly be used for travel now
      offload.enable = true;

      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };

    bluetooth.enable = true;
  };

  services.xserver.dpi = 144;

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
        useOSProber = false;
        splashImage = ./banana-grub-bg-dark.jpg;
      };
    };
  };
}
