# https://grahamc.com/blog/erase-your-darlings but / is ext4
{ partition }:
{ lib, ... }:
{
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkfs.ext4 -F ${partition}
  '';
}
