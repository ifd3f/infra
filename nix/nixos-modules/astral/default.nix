inputs: {
  imports = [
    inputs.vault-secrets.nixosModules.vault-secrets
    # inputs.nix-ld.nixosModules.nix-ld
    inputs.home-manager-stable.nixosModules.default

    ./flake-input.nix

    ./hw
    ./mount-root-to-home.nix

    ({ pkgs, ... }: {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
      nixpkgs.overlays = [ inputs.self.overlays.default ];
      astral.inputs = inputs;
    })

    ./acme.nix
    ./zfs-utils.nix
    ./virt
    ./vfio.nix
    ./xmonad
    ./custom-tty
    ./program-sets
    ./nix-utils.nix
    ./custom-nginx-errors

    ./cachix.nix
    ./infra-update.nix
    ./ci.nix

    ./net
    ./users

    ./monitoring-node
    ./backup
    ./tailscale.nix
  ];

  system.stateVersion = "22.11";
}
