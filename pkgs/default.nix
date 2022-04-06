{ self, pkgs }:
let
  flakeTime = self.sourceInfo.lastModified;
  gh-ci-matrix = pkgs.callPackage ./gh-ci-matrix { inherit self; };
  ci-import-and-tag-docker = pkgs.callPackage ./ci-import-and-tag-docker {};
  gigarouter-image = self.nixosConfigurations.gigarouter.config.system.build.vm;
  vendored-images = import ./images/vendored { inherit pkgs; };

  upload-all-to-lxd = pkgs.callPackage ./upload-all-to-lxd { inherit flakeTime; convertImage = build-support.convertImage; lxdUtils = build-support.lxdUtils; vendored-talos-os = vendored-images.vendored-talos-os; };

  build-support = import ./build-support { inherit pkgs; };

in vendored-images //
  { inherit gh-ci-matrix ci-import-and-tag-docker gigarouter-image upload-all-to-lxd; }

