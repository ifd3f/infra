{
  nix.settings = {
    substituters =
      [ "https://cache.nixos.org/" "https://astralbijection.cachix.org" ];
    trusted-public-keys = [
      "astralbijection.cachix.org-1:Vt/mfnVfzonOeQEN6MzRQs2qlHuzFYkNg6EqxdUhjrs="
    ];
  };
}

