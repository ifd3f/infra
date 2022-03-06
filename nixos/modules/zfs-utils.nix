# See also: https://nixos.wiki/wiki/NixOS_on_ZFS

{ config, lib, ... }:
with lib; {
  options.astral.zfs-utils.enable = mkOption {
    description = "Enable to set up utils for ZFS.";
    default = true;
    type = types.bool;
  };

  config = mkIf config.astral.zfs-utils.enable {
    boot = {
      initrd.supportedFilesystems = [ "zfs" ];
      loader.grub.copyKernels = true;
      supportedFilesystems = [ "zfs" ];
      zfs.requestEncryptionCredentials = true;
    };
    services.zfs.autoScrub.enable = true;
  };
}
