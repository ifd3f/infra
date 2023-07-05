{
  fileSystems."/" = {
    device = "rootfs";
    fsType = "tmpfs";
    options = [ "size=256M" ];
  };

  fileSystems."/nix" = {
    device = "ssdpool/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "ssdpool/home";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "ssdpool/var";
    fsType = "zfs";
  };

  fileSystems."/etc" = {
    device = "ssdpool/etc";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/18E0-62AE";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
