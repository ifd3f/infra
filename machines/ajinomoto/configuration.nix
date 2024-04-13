inputs:
{ config, lib, pkgs, modulesPath, ... }:
with lib; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.self.nixosModules.server

    (import ./boot.nix inputs)
    ./fs.nix
  ];

  astral = {
    users.alia.enable = true;
    users.astrid.enable = true;
    virt = {
      docker.enable = true;
      libvirt.enable = true;
    };
    tailscale.enable = mkForce false;
    monitoring-node.enable = mkForce false;

    backup.db.enable = false;
  };

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "boop";
    domain = "h.astrid.tech";

    hostId = "681441e3"; # Required for ZFS
    useDHCP = true;
  };
}
