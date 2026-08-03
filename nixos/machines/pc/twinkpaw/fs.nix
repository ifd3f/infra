{
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
}
