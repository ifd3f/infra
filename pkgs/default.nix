{ self, nixos-generators, pkgs }:
let
  flakeTime = self.sourceInfo.lastModified;
  gh-ci-matrix = pkgs.callPackage ./gh-ci-matrix { inherit self; };
  ci-import-and-tag-docker = pkgs.callPackage ./ci-import-and-tag-docker {};
  gigarouter-image = import ./images/gigarouter {
    inherit nixos-generators pkgs;
  };
  vendored-images = import ./images/vendored { inherit pkgs; };

  upload-all-to-lxd = pkgs.callPackage ./upload-all-to-lxd {
    inherit flakeTime gigarouter-image;
    convertImage = build-support.convertImage;
    lxdUtils = build-support.lxdUtils;
    vendored-talos-os = vendored-images.vendored-talos-os;
    vendored-centos-8-cloud = vendored-images.vendored-centos-8-cloud;
  };

  build-support = import ./build-support { inherit pkgs; };

  internal-libvirt-images = pkgs.linkFarm "internal-libvirt-images" [
    { name = "centos-8.qcow2"; path = vendored-images.vendored-centos-8-cloud; }
    { name = "gigarouter.qcow2"; path = "${gigarouter-image}/nixos.qcow2"; }
  ];

in vendored-images //
  { inherit internal-libvirt-images gh-ci-matrix ci-import-and-tag-docker gigarouter-image upload-all-to-lxd; }

