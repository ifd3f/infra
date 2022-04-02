{ self, pkgs }:
let
  lxdwriters = import ./lxdwriters.nix { inherit pkgs; };
  flakeTime = self.sourceInfo.lastModified;
in {
  internal-lxd-simplestreams-tree = pkgs.callPackage ./internal-lxd-simplestreams-tree
    (lxdwriters // { inherit flakeTime; });
}

