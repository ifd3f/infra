# Miscellaneous flags useful for systems with ZFS.
{ config, lib, ... }:
let
  cfg = config.astral.zfs-utils;
in
{
  options.astral.zfs-utils = {
    enable = lib.mkEnableOption "astral.zfs-utils";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      initrd.supportedFilesystems = [ "zfs" ];
      loader.grub.copyKernels = true;
      supportedFilesystems = [ "zfs" ];
      zfs = {
        requestEncryptionCredentials = true;
        forceImportRoot = false; # may cause data loss otherwise
      };
    };
    services.zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };
  };
}
