{ config, lib, ... }:
with lib; {
  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      splashImage = ./nerd-emoji.jpg;
    };
  };

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ehci_pci" "uhci_hcd" "hpsa" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    mkDefault config.hardware.enableRedistributableFirmware;
}
