{ self, nixos-generators, nixpkgs, pkgs }:
let
  flakeTime = self.sourceInfo.lastModified;
  vendored-images = import ./images/vendored { inherit pkgs; };
  build-support = import ./build-support { inherit nixos-generators pkgs; };
in vendored-images // {

  ci-action-runner = pkgs.callPackage ./ci-action-runner { inherit self; };
  update-ci-runner = pkgs.writeScriptBin "update-ci-runner" ''
    cp ${self.packages.${pkgs.system}.ci-action-runner} .github/workflows/check-targets.yml
  '';

  ci-import-and-tag-docker = pkgs.callPackage ./ci-import-and-tag-docker { };
  installer-iso = pkgs.callPackage ./images/installer-iso { inherit self; };

  ifd3f-infra-scripts = pkgs.callPackage ./../../scripts { };

  internal-libvirt-images = pkgs.linkFarm "internal-libvirt-images" [{
    name = "centos-8.qcow2";
    path = vendored-images.vendored-centos-8-cloud;
  }];

  win10hotplug = pkgs.callPackage ./win10hotplug { };
}

