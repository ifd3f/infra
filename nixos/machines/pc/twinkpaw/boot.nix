{ pkgs, ... }:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = false;
      splashImage = pkgs.astral.helpers.adjustImageBrightness "twinkpaw-bg" (-10) ./bg.jpg;
    };
  };

  boot.initrd.systemd.enable = true;

  boot.kernelParams = [
    # preferred for passthru
    "intel_iommu=on"
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
}
