{
  fileSystems."/" = {
    device = "tank/enc/root";
    fsType = "zfs";
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
