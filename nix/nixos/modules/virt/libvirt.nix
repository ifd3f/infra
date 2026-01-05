{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.virt.libvirt;
in
{
  options.astral.virt.libvirt = {
    enable = lib.mkEnableOption "astral.virt.libvirt";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "kvm-intel" ];
      binfmt.emulatedSystems = [ "aarch64-linux" ];
    };

    virtualisation.libvirtd.enable = true;
  };
}
