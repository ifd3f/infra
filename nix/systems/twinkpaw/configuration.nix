# My Surface Pro.
{ config, pkgs, lib, inputs, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.laptop
    inputs.self.nixosModules.pc
  ] ++ (with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-ssd
  ]);

  time.timeZone = "US/Pacific";

  # so i can be a *gamer*
  programs.steam.enable = true;

  astral = {
    xmonad.enable = true;
    tailscale.enable = mkForce false;
  };

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  networking = {
    hostName = "twinkpaw";

    hostId = "fe3434ab";
    networkmanager.enable = true;
    useDHCP = false;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
      # splashImage = TODO;
    };
  };

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-uuid/013a892f-48ce-432c-a9bb-9b57d8f0d6b5";
    };
  };
}
