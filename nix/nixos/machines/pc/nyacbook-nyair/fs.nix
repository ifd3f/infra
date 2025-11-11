{
  fileSystems."/" = {
    device = "root-tmpfs";
    fsType = "tmpfs";
  };

  fileSystems."/nix" = {
    device = "rpool/nix";
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

  fileSystems."/var" = {
    device = "rpool/enc/var";
    fsType = "zfs";
  };

  fileSystems."/tmp" = {
    device = "rpool/enc/tmp";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C839-101A";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
