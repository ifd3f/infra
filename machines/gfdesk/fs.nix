{
  boot.zfs.forceImportAll = true;

  fileSystems."/" = {
    device = "rootfs";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=256M"
      "mode=755"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8abd40bb-72a3-4334-b7bc-108fbcd4c1a4";
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

  fileSystems."/tmp" = {
    device = "nvmepool/tmp";
    fsType = "zfs";
  };

  swapDevices = [ ];
}
