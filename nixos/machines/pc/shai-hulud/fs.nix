{
  fileSystems."/" = {
    device = "tank/enc/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4DC0-283F";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "tank/enc/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "tank/nix";
    fsType = "zfs";
  };

  swapDevices = [ ];
}
