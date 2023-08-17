{ self, nixpkgs-stable, ... }:
let lib = nixpkgs-stable.lib;
in rec {
  ifd3f-ca = import ../../ca { inherit lib; };
  sshKeyDatabase = import ../../ssh_keys;

  ci = import ../ci.nix { inherit self lib; };
} // (import ./github-actions.nix { inherit lib; })
