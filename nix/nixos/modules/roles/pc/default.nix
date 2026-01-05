{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.astral.roles.pc;
  extraHosts = "/var/extraHosts";
in
{
  imports = [
    ./graphics.nix
    ./peripherals.nix
    ./input.nix
    ./audio.nix
    ./dev.nix
  ];

  options.astral.roles.pc = lib.mkEnableOption "PC role";

  config = lib.mkIf cfg.enable {
    astral.roles.common.enable = true;
    astral.zfs-utils.enable = true;

    astral.program-sets = {
      fonts.enable = true;
      security.enable = true;
      utils.enable = true;

      graphics.basics.enable = true;
      graphics.cad.enable = true;
      graphics.dev.enable = true;
      graphics.drone.enable = true;
      graphics.games.enable = true;
      graphics.internet.enable = true;
      graphics.media-production.enable = true;
      graphics.office.enable = true;
      graphics.radio.enable = true;
    };

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
  };
}
