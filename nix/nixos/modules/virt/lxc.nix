{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.astral.virt.lxc;
in
{
  options.astral.virt.lxc = {
    enable = lib.mkEnableOption "astral.virt.lxc";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      lxc.enable = true;
      incus.enable = true;
    };
    boot.kernelModules = [ "vhost_vsock" ];
  };
}
