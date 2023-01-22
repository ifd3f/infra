# Some headless server that likely runs 24/7
{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./astral ];

  # Auto-optimize/GC store on a much more frequent basis than the PC's.
  nix.gc = lib.mkForce {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  # Hashicorp Vault secrets uwu
  vault-secrets.vaultAddress = "https://secrets.astrid.tech";

  # Use a stable, frozen-version hardened kernel
  boot.kernelPackages = pkgs.linuxPackages_5_15_hardened;

  # Enable SSH in initrd for debugging
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [ inputs.self.lib.sshKeyDatabase.users.astrid ];
  };

  astral = {
    acme.enable = true;
    # backup.services.enable = true;
    custom-tty.enable = true;
    infra-update.enable = false;
    net.sshd.enable = true;
    monitoring.node.enable = true;

    users = {
      github.enable = true;
      terraform.enable = true;
    };

    ci.needs = [ "nixos-system-__baseServer" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # embed the home-manager into the configuration
    users.astrid = inputs.self.homeModules.astral-cli;
  };

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
}
