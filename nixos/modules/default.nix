inputs:
{ ... }: {
  imports = [
    { nixpkgs.config.allowUnfree = true; }
    ./cachix.nix
    ./program-sets
    ./nix-unstable.nix
    ./infra-update.nix
  ];
}
