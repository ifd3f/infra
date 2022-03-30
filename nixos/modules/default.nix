{ nixos-hardware, qmk_firmware, homeModules }:
{ ... }: {
  imports = [
    (import ./hw { inherit nixos-hardware qmk_firmware; })

    ({ pkgs, ... }: {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
    })

    ./zfs-utils.nix
    ./virt
    ./program-sets
    ./nix-utils.nix

    ./cachix.nix
    ./infra-update.nix

    ./net
    ./users

    (import ./roles { inherit homeModules; })
  ];
}
