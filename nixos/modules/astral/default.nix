{ nixos-hardware, qmk_firmware, homeModules, sshKeyDatabase }:
{ ... }: {
  imports = [
    (import ./hw { inherit nixos-hardware qmk_firmware; })

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
    (import ./users { inherit sshKeyDatabase; })

    (import ./roles { inherit homeModules sshKeyDatabase; })
  ];

  system.stateVersion = "22.11";
}
