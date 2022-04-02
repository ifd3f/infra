{ homeModules, sshKeyDatabase }: {
  imports = [
    (import ./server.nix { inherit homeModules sshKeyDatabase; })
    ./laptop.nix
    ./pc.nix
  ];
}
