{ self, nixos-generators, nixpkgs, pkgs }:
let
  flakeTime = self.sourceInfo.lastModified;
  vendored-images = import ./images/vendored { inherit pkgs; };
  build-support = import ./build-support { inherit nixos-generators pkgs; };
in vendored-images // {

  gh-ci-matrix = pkgs.callPackage ./gh-ci-matrix { inherit self; };
  ci-import-and-tag-docker = pkgs.callPackage ./ci-import-and-tag-docker { };
  installer-iso = pkgs.callPackage ./images/installer-iso { inherit self; };

  upload-all-to-lxd = pkgs.callPackage ./upload-all-to-lxd {
    inherit flakeTime nixpkgs;
    convertImage = build-support.convertImage;
    lxdUtils = build-support.lxdUtils;
    gigarouterModule = self.nixosModules.gigarouter;
    vendored-talos-os = vendored-images.vendored-talos-os;
  };

  internal-libvirt-images = pkgs.linkFarm "internal-libvirt-images" [{
    name = "centos-8.qcow2";
    path = vendored-images.vendored-centos-8-cloud;
  }];

  win10hotplug = pkgs.callPackage ./win10hotplug { };
}

