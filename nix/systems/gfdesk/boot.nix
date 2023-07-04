{ config, lib, ... }:
with lib; {
  # Use the GRUB boot loader in BIOS mode because tfw no EFI
  boot.loader.grub = {
    enable = true;
    copyKernels = true;
    device = "/dev/disk/by-id/usb-HP_iLO_Internal_SD-CARD_000002660A01-0:0";
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
