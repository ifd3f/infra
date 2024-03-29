# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "root-tmpfs";
    fsType = "tmpfs";
  };

  fileSystems."/nix" = {
    device = "bigdiskenergy/nix";
    fsType = "zfs";
  };

  fileSystems."/etc" = {
    device = "bigdiskenergy/enc/etc";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "bigdiskenergy/enc/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9273-1FCA";
    fsType = "vfat";
  };

  fileSystems."/var" = {
    device = "bigdiskenergy/enc/var";
    fsType = "zfs";
  };

  fileSystems."/root/disk-keys" = {
    device = "bigdiskenergy/enc/keys";
    fsType = "zfs";
  };

  fileSystems."/home/root/disk-keys" = {
    device = "/root/disk-keys";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
