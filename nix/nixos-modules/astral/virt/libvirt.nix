{ config, lib, pkgs, ... }:
with lib; {
  options.astral.virt.libvirt = {
    enable = mkOption {
      description = "Use libvirt stuff";
      default = false;
      type = types.bool;
    };

    virt-manager.enable = mkOption {
      description = "Add virt-manager";
      default = false;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.virt.libvirt;
  in mkIf cfg.enable {
    boot = {
      kernelModules = [ "kvm-intel" ];
      binfmt.emulatedSystems = [ "aarch64-linux" ];
    };

    virtualisation.libvirtd = {
      enable = true;
      qemu.ovmf = {
        enable = true;
        packages = with pkgs;
          [
            OVMFFull.fd
            # broken as of upgrade to 23.11
            # pkgsCross.aarch64-multiplatform.OVMF.fd
          ];
      };
    };

    security.polkit.enable = true;

    environment.systemPackages = with pkgs;
      ([ netcat ] # netcat for qemu+ssh:// connections
        ++ (if cfg.virt-manager.enable then [ virt-manager ] else [ ]));
  };
}
