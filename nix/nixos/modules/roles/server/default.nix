# Some headless server that likely runs 24/7
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.astral.roles.server;
in
{
  imports = [
    "${inputs.self}/nix/nixos/modules/program-sets/fonts.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/security.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/utils.nix"

    "${inputs.self}/nix/nixos/modules/acme.nix"
    "${inputs.self}/nix/nixos/modules/zfs-utils.nix"
  ];

  options.astral.roles.server = lib.mkEnableOption "Server role";

  config = lib.mkIf cfg.enable {
    astral.roles.common.enable = true;

    # Auto-optimize/GC store on a much more frequent basis than the PC's.
    nix.gc = lib.mkForce {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

    # Use a hardened kernel
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_hardened;

    # Enable SSH in initrd for debugging
    # boot.initrd.network.ssh = {
    #   enable = true;
    #   authorizedKeys = [ inputs.self.lib.sshKeyDatabase.users.astrid ];
    # };

    # home-manager = {
    #   useGlobalPkgs = true;
    #   useUserPackages = true;

    #   # embed the home-manager into the configuration
    #   users.astrid = inputs.self.homeModules.astral-cli;
    # };

    # Passwordless sudo
    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;
  };
}
