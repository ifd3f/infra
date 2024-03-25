{
  boot.zfs.forceImportAll = true;

  fileSystems."/" = {
    device = "rootfs";
    fsType = "tmpfs";
  };

  fileSystems."/tmp" = {
    device = "rpool/enc/tmp";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/nix";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "rpool/enc/var";
    fsType = "zfs";
  };

  fileSystems."/etc" = {
    device = "rpool/enc/etc";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/enc/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D30E-26C7";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
