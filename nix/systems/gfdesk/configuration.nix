# The desk that is used by Good Friends.
{ lib, inputs, modulesPath, ... }:
with lib; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.self.nixosModules.server

    ./boot.nix
    ./fs.nix
    ./net.nix
  ];

  astral = {
    users.alia.enable = true;
    virt = {
      docker.enable = true;
      libvirt.enable = true;
    };
    monitoring-node.scrapeTransport = "tailscale";
    tailscale.enable = mkForce false;
  };

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "gfdesk";
    domain = "h.astrid.tech";

    hostId = "6d1020a1"; # Required for ZFS
  };
}
