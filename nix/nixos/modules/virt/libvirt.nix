{ pkgs, ... }:
{
  boot = {
    kernelModules = [ "kvm-intel" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  virtualisation.libvirtd.enable = true;
}
