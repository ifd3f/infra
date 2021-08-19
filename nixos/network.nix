{
  network.description = "Hypervisor Cluster";
  network.enableRollback = true;

  vm =
    { config, pkgs, ... }:
    { 

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
      deployment = {
        targetHost = "192.168.100.184";
        #targetUser = "root";
      };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only
  boot.initrd.supportedFilesystems = ["zfs"]; # boot from zfs
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
    };
}