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
      lxd.enable = true;
      lxc.enable = true;
    };
  };
}
