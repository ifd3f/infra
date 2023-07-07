{
  fileSystems."/" = {
    device = "rootfs";
    fsType = "tmpfs";
    options = [ "size=256M" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/59f761af-8370-4cc4-819e-593aee41d887";
    fsType = "ext4";
  };

  fileSystems."/etc" = {
    device = "ssdpool/etc";
    fsType = "zfs";
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

  swapDevices = [ ];
}
