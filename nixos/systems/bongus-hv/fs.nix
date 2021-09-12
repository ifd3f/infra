let devices = {
  bootDisk = "/dev/disk/by-id/scsi-3600508b1001c5e757c79ba52c727a91f";
  bootPart = "/dev/disk/by-id/scsi-3600508b1001c5e757c79ba52c727a91f-part1";
  rootPart = "/dev/disk/by-id/scsi-3600508b1001c5e757c79ba52c727a91f-part2";
  vmsPart = "/dev/disk/by-id/scsi-3600508b1001c5e757c79ba52c727a91f-part3";
}; in {
  inherit devices;
}