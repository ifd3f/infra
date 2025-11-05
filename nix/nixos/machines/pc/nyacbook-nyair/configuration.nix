{ inputs, pkgs, ... }:
{
  imports = [
    # TODO
    # ./hardware-configuration.nix
    # ./fs.nix
    "${inputs.self}/nix/nixos/modules/roles/pc"
  ];

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "nyacbook-nyair";
    hostId = "db699f52";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "25.05";
}
