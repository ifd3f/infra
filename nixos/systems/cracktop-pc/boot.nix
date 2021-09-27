{
  boot.loader = {
    grub.copyKernels = true;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}