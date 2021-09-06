{ config, lib, pkgs, modulesPath, ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.device = "/dev/sda"; # HP G8 only supports BIOS, not UEFI
  boot.zfs.requestEncryptionCredentials = true;

  networking.hostId = "6d1020a1";  # Required for ZFS
  networking.useDHCP = false;

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;
  networking.interfaces.eno3.useDHCP = true;
  networking.interfaces.eno4.useDHCP = true;
}