# for CPE 422
{ config, lib, pkgs, ... }:
with lib; {
  options.astral.virt.vbox = {
    enable = mkOption {
      description = "Use CPE 422 VirtualBox configs";
      default = false;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.virt.docker;
  in mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;
    environment.etc."/etc/vbox/networks.conf".text = "* 0.0.0.0/0 ::/0";
  };
}
