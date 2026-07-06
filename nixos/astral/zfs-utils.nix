# Miscellaneous flags useful for systems with ZFS.
{ config, lib, ... }:
let
  cfg = config.astral.zfs-utils;
in
{
  options.astral.zfs-utils = {
    enable = lib.mkEnableOption "Common ZFS tweaks";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      initrd.supportedFilesystems = [ "zfs" ];
      loader.grub.copyKernels = true;
      supportedFilesystems = [ "zfs" ];
      zfs = {
        requestEncryptionCredentials = true;

        # prevent accidental data loss. just in case
        forceImportAll = false;
        forceImportRoot = false;
      };
    };
    services.zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };
  };
}
