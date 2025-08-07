{ pkgs, ... }:
{
  virtualisation = {
    lxc.enable = true;
    lxd = {
      enable = true;
      package = pkgs.lxd.override { useQemu = true; };
      recommendedSysctlSettings = true;
    };
  };
  boot.kernelModules = [ "vhost_vsock" ];
}
