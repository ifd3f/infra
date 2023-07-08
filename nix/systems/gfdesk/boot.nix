{ config, lib, ... }:
with lib; {
  # Use the GRUB boot loader in BIOS mode because tfw no EFI
  boot.loader.grub = {
    enable = true;
    copyKernels = true;
    device = "/dev/disk/by-id/scsi-3600508b1001c8de11fa59a8fab10513d";
    splashImage = ./homura.jpg;
  };

  boot.initrd.availableKernelModules =
    [ "ehci_pci" "ata_piix" "uhci_hcd" "hpsa" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    mkDefault config.hardware.enableRedistributableFirmware;
}
