{
  nixpkgs.config.allowUnfree = true;
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "b6079f73c67cda0d" ];
  };
}
