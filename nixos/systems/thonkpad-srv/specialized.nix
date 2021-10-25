{ config, lib, pkgs, ... }: {
  time.timeZone = "US/Pacific";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  networking = {
    hostName = "thonkpad-srv";
    domain = "id.astrid.tech";
    hostId = "49e32584"
    
    useDHCP = false;
    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    interfaces.wwp0s29u1u4.useDHCP = true;
  }

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
    users = { astrid = import ../../users/astrid.nix; };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
};
