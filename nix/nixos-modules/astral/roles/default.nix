{
  imports = [
    ./server.nix
    ./laptop.nix
    ./pc.nix

    ./auth-dns
    ./armqr
    ./monitoring
    ./piwigo
    ./sso-provider
  ];
}
