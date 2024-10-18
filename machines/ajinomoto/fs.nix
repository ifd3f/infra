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
    device = "/dev/disk/by-uuid/1f75c5dd-1fc2-4300-8946-cb8c327231af";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    device = "ajinomoto/nix";
    fsType = "zfs";
  };

  fileSystems."/etc" = {
    device = "ajinomoto/enc/etc";
    fsType = "zfs";
  };

  fileSystems."/tmp" = {
    device = "ajinomoto/enc/tmp";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "ajinomoto/enc/var";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "ajinomoto/enc/home";
    fsType = "zfs";
  };

  swapDevices = [ ];
}
