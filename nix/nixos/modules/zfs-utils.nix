# Miscellaneous flags useful for systems with ZFS.
{
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
}
