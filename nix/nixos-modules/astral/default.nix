inputs: {
  imports = [
    inputs.vault-secrets.nixosModules.vault-secrets
    inputs.nix-ld.nixosModules.nix-ld
    inputs.home-manager-stable.nixosModule
    ./hw
    ./mount-root-to-home.nix

    ({ pkgs, ... }: {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
      nixpkgs.overlays = [ inputs.self.overlays.default ];
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
    (import ./users inputs)

    ./monitoring-node
    (import ./backup inputs)
    ./tailscale.nix
  ];

  system.stateVersion = "22.11";
}
