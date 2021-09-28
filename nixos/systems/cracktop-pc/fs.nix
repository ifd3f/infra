let devices = {
  rootDisk = "/dev/disk/by-id/ata-SAMSUNG_MZNLF128HCHP-000H1_S2HUNXBG806927";
  bootPart = "${devices.rootDisk}-part1";
  rootPart = "${devices.rootDisk}-part2";
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

      "/home" = {
        device = "rpool/local/home";
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
