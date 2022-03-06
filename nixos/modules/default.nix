inputs:
{ ... }: {
  imports = [
    { nixpkgs.config.allowUnfree = true; }
    {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
    }
    ./cachix.nix
    ./program-sets
    ./nix-unstable.nix
    ./infra-update.nix
    ./net/sshd.nix
    ./net/zerotier.nix
  ];
}
