{ homeModules, self }: {
  imports = [
    (import ./server.nix { inherit homeModules self; })
    ./laptop.nix
    ./pc.nix
  ];
}
