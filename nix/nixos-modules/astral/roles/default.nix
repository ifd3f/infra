{ homeModules, self }: {
  imports = [
    (import ./server.nix { inherit homeModules self; })
    ./laptop.nix
    ./pc.nix

    ./akkoma
    ./auth-dns
    ./armqr
    ./monitoring
    ./piwigo
    ./sso-provider
  ];
}
