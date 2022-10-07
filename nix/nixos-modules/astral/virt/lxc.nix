{ config, lib, pkgs, ... }:
with lib; {
  options.astral.virt.lxc = {
    enable = mkOption {
      description = "Use LXC stuff";
      default = false;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.virt.lxc;
  in mkIf cfg.enable {
    virtualisation = {
      lxc = {
        enable = true;
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
