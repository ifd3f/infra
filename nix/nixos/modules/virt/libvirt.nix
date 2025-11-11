{ pkgs, lib, ... }:
{
  boot = {
    #kernelModules = lib.optional (pkgs.system == "x86_64-linux") [ "kvm-intel" ];
    binfmt.emulatedSystems = lib.optional (pkgs.system == "x86_64-linux") "aarch64-linux";
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
