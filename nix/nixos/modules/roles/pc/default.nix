{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  extraHosts = "/var/extraHosts";
in
{
  imports = [
    "${inputs.self}/nix/nixos/modules/roles/common.nix"

    "${inputs.self}/nix/nixos/modules/program-sets/fonts.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/security.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/utils.nix"

    "${inputs.self}/nix/nixos/modules/program-sets/graphics/basics.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/graphics/cad.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/graphics/dev.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/graphics/drone.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/graphics/games.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/graphics/internet.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/graphics/media-production.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/graphics/office.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/graphics/radio.nix"

    "${inputs.self}/nix/nixos/modules/zfs-utils.nix"

    ./graphics.nix
    ./peripherals.nix
    ./input.nix
    ./audio.nix
    ./dev.nix
  ];

  services.tailscale.enable = true;
  services.resolved.enable = true;
  networking.networkmanager.enable = true;

  # Enable SSH in initrd for debugging or disk key entry
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [ inputs.self.lib.sshKeyDatabase.users.astrid ];
  };

  users.mutableUsers = true;
  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };

  networking.nftables.enable = true;

  # Things from the old system not yet ported over.
  #
  # astral = {
  #   custom-tty.enable = true;
  #   # infra-update = {
  #   #   enable = true;
  #   #   dates = "*-*-* 3:00:00 US/Pacific";
  #   # };
  # };

  services.flatpak.enable = true;

  services.upower.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
