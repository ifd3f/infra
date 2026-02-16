{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./fs.nix
    ./surface.nix
    "${inputs.self}/nix/nixos/modules/roles/pc"
  ];

  time.timeZone = "US/Pacific";

  networking = {
    hostName = "shai-hulud";
    hostId = "49e32584";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
      splashImage =
        with inputs.self.legacyPackages.${pkgs.system}.helpers;
        adjustImageBrightness "shai-hulud-bg" (-30) ./shai-hulud.jpg;
    };
  };

  services.xserver.dpi = 180;

  system.stateVersion = "22.11";
}
