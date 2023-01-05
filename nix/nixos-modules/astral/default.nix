{ inputs, ... }: {
  imports = [
    inputs.nix-ld.nixosModules.nix-ld
    inputs.home-manager-unstable.nixosModule
    ./hw

    ({ pkgs, inputs, ... }: {
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
    ./users

    ./monitoring
  ];

  system.stateVersion = "22.11";
}
