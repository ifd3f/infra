{ pkgs, ... }:
{
  virtualisation = {
    lxc.enable = true;
    lxd = {
      enable = true;
      recommendedSysctlSettings = true;
    };
  };
  boot.kernelModules = [ "vhost_vsock" ];
}
