inputs:
{ ... }: {
  imports = [
    {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
    }
    ./program-sets
    ./nix-utils.nix

    ./cachix.nix
    ./infra-update.nix

    ./net/sshd.nix
    ./net/zerotier.nix
    ./users
  ];
}
