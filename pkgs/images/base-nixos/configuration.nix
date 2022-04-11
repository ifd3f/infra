# A base VM image for virtualized NixOS machines.

{ config, pkgs, modulesPath, ... }: {
  services.cloud-init = {
    enable = true;
    network.enable = true;
  };
}
