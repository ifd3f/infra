{ config, lib, pkgs, ... }:
with lib; {
  options.astral.virt.libvirt = {
    enable = mkOption {
      description = "Use libvirt stuff";
      default = true;
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

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.ovmf.enable = true;
      };
    };

    environment.systemPackages = with pkgs;
    # netcat for qemu+ssh:// connections
      ([ netcat ] ++ (if cfg.virt-manager.enable then virt-manager else [ ]));
  };
}
