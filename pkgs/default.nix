{ self, nixos-generators, nixpkgs, pkgs }:
let
  flakeTime = self.sourceInfo.lastModified;
  gh-ci-matrix = pkgs.callPackage ./gh-ci-matrix { inherit self; };
  ci-import-and-tag-docker = pkgs.callPackage ./ci-import-and-tag-docker {};
  vendored-images = import ./images/vendored { inherit pkgs; };

  upload-all-to-lxd = pkgs.callPackage ./upload-all-to-lxd {
    inherit flakeTime nixpkgs;
    convertImage = build-support.convertImage;
    lxdUtils = build-support.lxdUtils;
    gigarouterModule = self.nixosModules.gigarouter;
    vendored-talos-os = vendored-images.vendored-talos-os;
  };

  build-support = import ./build-support { inherit nixos-generators pkgs; };

  internal-libvirt-images = pkgs.linkFarm "internal-libvirt-images" [
    { name = "centos-8.qcow2"; path = vendored-images.vendored-centos-8-cloud; }
  ];

in vendored-images //
  { inherit internal-libvirt-images gh-ci-matrix ci-import-and-tag-docker upload-all-to-lxd; }

