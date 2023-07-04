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

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C2BA-585D";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
