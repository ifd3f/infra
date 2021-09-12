let fs = import ./fs.nix; in
{
  # Use the GRUB 2 boot loader.
  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      copyKernels = true;
      device = fs.devices.bootDisk; # HP G8 only supports BIOS, not UEFI
    };

    initrd = {
      availableKernelModules = [ "ehci_pci" "ata_piix" "uhci_hcd" "hpsa" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    extraModulePackages = [ ];
  };
}
