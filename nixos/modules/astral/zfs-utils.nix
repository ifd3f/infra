# See also: https://nixos.wiki/wiki/NixOS_on_ZFS

{ config, lib, ... }:
with lib; {
  # Only enable these configs if ZFS is even enabled in the first place
  config = mkIf config.boot.zfs.enabled {
    boot = {
      initrd.supportedFilesystems = [ "zfs" ];
      loader.grub.copyKernels = true;
      supportedFilesystems = [ "zfs" ];
      zfs.requestEncryptionCredentials = true;
    };
    services.zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };
  };
}
