{ pkgs, ... }:
{
  virtualisation = {
    lxc.enable = true;
    incus.enable = true;
  };
  boot.kernelModules = [ "vhost_vsock" ];
}
