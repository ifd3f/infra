{ self, pkgs }:
let
  lxdwriters = import ./lxdwriters.nix { inherit pkgs; };
  flakeTime = self.sourceInfo.lastModified;
in rec {
  internal-lxd-simplestreams-tree = pkgs.callPackage ./internal-lxd-simplestreams-tree (lxdwriters // { inherit flakeTime; });

  internal-lxd-simplestreams = pkgs.callPackage ./images/internal-lxd-simplestreams { inherit internal-lxd-simplestreams-tree; };

  gh-ci-matrix = pkgs.callPackage ./gh-ci-matrix { inherit self; };

  docker-tars = pkgs.linkFarm "docker-tars" [
    {
      name = "internal-lxd-simplestreams.tar.gz";
      path = internal-lxd-simplestreams;
    }
  ];

  ci-import-and-tag-docker = pkgs.callPackage ./ci-import-and-tag-docker { inherit docker-tars; };
}

