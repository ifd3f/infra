let devices = {
  bootPart = "/dev/disk/by-uuid/13B8-1D70";
  rootPart = "/dev/disk/by-uuid/ec63ba76-98e8-4617-b962-cce291223c58";
}; in
{
  inherit devices;

  module = {
    fileSystems = {
      "/" = {
        device = devices.rootPart;
        fsType = "ext4";
      };

      "/nix" = {
        device = "rpool/local/nix";
        fsType = "zfs";
      };

      "/persist" = {
        device = "rpool/safe/persist";
        fsType = "zfs";
      };

      "/boot" = {
        device = devices.bootPart;
        fsType = "vfat";
      };
    };

    swapDevices = [ ];
  };
}
