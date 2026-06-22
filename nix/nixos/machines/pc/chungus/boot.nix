{ pkgs, inputs, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.enable = false;
  boot.loader.refind.enable = true;
}
