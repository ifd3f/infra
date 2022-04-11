{ pkgs, nixos-generators }: nixos-generators.nixosGenerate {
  inherit pkgs;
  modules = [
    ./configuration.nix
  ];
  format = "qcow";
}

