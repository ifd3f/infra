{ bongus_ip }:
{
  network.description = "Hypervisor Cluster";
  network.enableRollback = true;

  vm =
    { config, pkgs, ... }:
    { 
      imports =
        [ ./hardware/bongus.nix
          ./modules/server.nix
          ./modules/sshd.nix
        ];
    };
}