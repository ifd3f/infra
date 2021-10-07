# See also: https://nixos.wiki/wiki/NixOS_on_ZFS

{ ... }: {
  boot = {
    initrd.supportedFilesystems = [ "zfs" ];
    loader.grub.copyKernels = true;
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;
  };
}
