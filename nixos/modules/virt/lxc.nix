{ config, lib, pkgs, ... }:
with lib; {
  options.astral.virt.lxc = {
    enable = mkOption {
      description = "Use LXC stuff";
      default = true;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.virt.lxc;
  in mkIf cfg.enable {
    virtualisation = {
      lxc = {
        enable = true;
        lxcfs.enable = true;
        defaultConfig = "lxc.include = ${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf";
      };
      lxd = {
        enable = true;
        package = pkgs.lxd.override { useQemu = true; };
        recommendedSysctlSettings = true;
      };
    };
    boot.kernelModules = [ "vhost_vsock" ];
  };
}
