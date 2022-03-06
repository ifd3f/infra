# An old Thinkpad T420 to be used as a server.
{ ... }:
{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  astral.roles.server.enable = true;

  time.timeZone = "US/Pacific";

  boot.loader.grub = {
    enable = true;
    version = 2;
    copyKernels = true;
    device = "/dev/disk/by-id/ata-ST1000LM049-2GH172_WGS3DNXS";
    splashImage = ./thonk.png;
  };

  networking = {
    domain = "id.astrid.tech";
    hostId = "49e32584";

    useDHCP = false;
    interfaces.enp0s25.useDHCP = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # TODO refer to self.homeConfigurations."astrid@gfdesk" instead
    # users.astrid = self.homeModules.astrid_cli_full;
  };

  nixpkgs.config.allowUnfree = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
