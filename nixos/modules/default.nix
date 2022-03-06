inputs:
{ ... }: {
  imports = [
    ./cachix.nix
    ./program-sets
    ./nix-unstable.nix
    ./infra-update.nix
  ];
}
