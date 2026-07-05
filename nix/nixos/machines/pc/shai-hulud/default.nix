{ self, pkgs, ... }:
{
  _class = "nixos";
  nixpkgs.system = "x86_64-linux";
  networking = {
    hostName = "shai-hulud";
    hostId = "49e32584";
  };

  imports = [
    ./hardware-configuration.nix
    ./fs.nix
    ./surface.nix
  ];

  time.timeZone = "US/Pacific";

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
      splashImage =
        with self.legacyPackages.${pkgs.system}.helpers;
        adjustImageBrightness "shai-hulud-bg" (-30) ./shai-hulud.jpg;
    };
  };

  services.xserver.dpi = 180;

  system.stateVersion = "22.11";
}
