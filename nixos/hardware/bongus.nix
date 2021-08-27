{ config, lib, pkgs, modulesPath, ... }:

{

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only
  boot.zfs.requestEncryptionCredentials = true;

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelModules = [ "kvm-intel" ];

  networking.hostId = "6d1020a1";  # Required for ZFS
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  fileSystems."/" =
    { device = "rpool/local/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "rpool/safe/persist";
      fsType = "zfs";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/7E1C-2AE2";
      fsType = "vfat";
    };

  swapDevices = [ ];
}