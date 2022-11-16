{ modulesPath, config, lib, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  zramSwap.enable = true;

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    cleanTmpDir = true;

    # Contabo does not provide EFI, use GRUB
    loader.grub = {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
      efiSupport = false;
      enable = true;
      version = 2;
    };

    initrd.availableKernelModules =
      [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-part3";
    fsType = "ext4";
  };

  networking = {
    useDHCP = lib.mkDefault true;

    # IPv6 connectivity
    # See also: https://contabo.com/blog/adding-ipv6-connectivity-to-your-server/
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };

    interfaces.ens18.useDHCP = lib.mkDefault true;
  };
}
