{
  boot.zfs.forceImportAll = true;

  fileSystems."/" = {
    device = "rootfs";
    fsType = "tmpfs";
    options = [ "defaults" "size=256M" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "ssd/nix";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D30E-26C7";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "ssd/home";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "ssd/var";
    fsType = "zfs";
  };

  fileSystems."/etc" = {
    device = "ssd/etc";
    fsType = "zfs";
  };

  fileSystems."/tmp" = {
    device = "ssd/tmp";
    fsType = "zfs";
  };

  swapDevices = [ ];
}
