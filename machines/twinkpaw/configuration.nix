inputs:
{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.pc
    inputs.self.nixosModules.laptop
  ];

  time.timeZone = "US/Pacific";

  astral.tailscale.oneOffKey =
    "tskey-auth-kQpYuB2CNTRL-krpVu4TaHhBfxV7SWg3LgBtPG8t3QKyh4";

  # so i can be a *gamer*
  programs.steam.enable = true;

  services = { blueman.enable = true; };

  virtualisation.lxd.enable = true;

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  services.xserver.dpi = 209;

  networking = {
    hostName = "twinkpaw";

    hostId = "76d4a2bc";
    networkmanager.enable = true;
    useDHCP = false;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;

    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        useOSProber = false;
        splashImage = let
          image = with pkgs;
            runCommand "twinkpaw-bg.jpg" { } ''
              ${imagemagick}/bin/convert -brightness-contrast -10 ${
                ./bg.jpg
              } $out
            '';
        in "${image}";
      };
    };
  };
}
