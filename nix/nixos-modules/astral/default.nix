{ self, home-manager, nix-ld, homeModules }:
{ ... }: {
  imports = [
    nix-ld.nixosModules.nix-ld
    home-manager.nixosModule
    ./hw

    ({ pkgs, ... }: {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
    })

    ./zfs-utils.nix
    ./virt
    ./xmonad
    ./program-sets
    ./nix-utils.nix

    ./cachix.nix
    ./infra-update.nix

    ./net
    (import ./users { inherit self; })

    (import ./roles { inherit homeModules self; })
  ];

  system.stateVersion = "22.11";
}
