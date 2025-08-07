{ pkgs, ... }:
{
  boot = {
    kernelModules = [ "kvm-intel" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf = {
      enable = true;
      packages = with pkgs; [
        OVMFFull.fd
        # broken as of upgrade to 23.11
        # pkgsCross.aarch64-multiplatform.OVMF.fd
      ];
    };
  };
}
