{ self, home-manager, nix-ld, homeModules }:
{ ... }: {
  imports = [
    nix-ld.nixosModules.nix-ld
    home-manager.nixosModule
    ./hw

    ({ pkgs, ... }: {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
      nixpkgs.overlays = [ self.overlays.default ];
    })

    ./acme.nix
    ./zfs-utils.nix
    ./virt
    ./vfio.nix
    ./xmonad
    ./custom-tty
    ./program-sets
    ./nix-utils.nix

    ./cachix.nix
    ./infra-update.nix
    ./ci.nix

    ./net
    (import ./users { inherit self; })

    (import ./roles { inherit homeModules self; })
  ];

  system.stateVersion = "22.11";
}
