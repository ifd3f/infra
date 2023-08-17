{ self, nixpkgs-stable, ... }@inputs:
let lib = nixpkgs-stable.lib;
in rec {
  ifd3f-ca = import ../../ca { inherit lib; };
  sshKeyDatabase = import ../../ssh_keys;
  ci = import ../ci.nix { inherit self lib; };
  machines = import ../../machines inputs;
} // (import ./github-actions.nix { inherit lib; })
