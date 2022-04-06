{ self, pkgs }:
let
  flakeTime = self.sourceInfo.lastModified;
  gh-ci-matrix = pkgs.callPackage ./gh-ci-matrix { inherit self; };
  ci-import-and-tag-docker = pkgs.callPackage ./ci-import-and-tag-docker {};
  gigarouter-image = self.nixosConfigurations.gigarouter.config.system.build.vm;
  vendored-images = import ./images/vendored { inherit pkgs; };

in vendored-images //
  { inherit gh-ci-matrix ci-import-and-tag-docker gigarouter-image; }

