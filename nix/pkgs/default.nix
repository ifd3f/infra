{ self, nixos-generators, nixpkgs-stable, ... }:
pkgs:
let
  nixpkgs = nixpkgs-stable;
  flakeTime = self.sourceInfo.lastModified;
  vendored-images = import ./images/vendored { inherit pkgs; };
  build-support = import ./build-support { inherit nixos-generators pkgs; };
in vendored-images // rec {
  authelia-bin = pkgs.callPackage ./authelia-bin.nix { };

  update-ci-workflow = pkgs.callPackage ./update-ci-workflow { inherit self; };
  scan-ci-host-keys = pkgs.callPackage ./scan-ci-host-keys { inherit self; };

  ci-import-and-tag-docker = pkgs.callPackage ./ci-import-and-tag-docker { };
  installer-iso =
    pkgs.callPackage ./images/installer-iso { inherit self nixpkgs; };

  ifd3f-infra-scripts = pkgs.callPackage ./../../scripts { };

  internal-libvirt-images = pkgs.linkFarm "internal-libvirt-images" [{
    name = "centos-8.qcow2";
    path = vendored-images.vendored-centos-8-cloud;
  }];

  win10hotplug = pkgs.callPackage ./win10hotplug { };

  surface-screen-rotate = pkgs.runCommand "surface-screen-rotate" { } ''
    mkdir -p $out/bin
    ln -s ${./surface-screen-rotate.py} $out/bin/surface-screen-rotate
  '';

  vault-push-approles = with pkgs;
    writeScriptBin "vault-push-approles" ''
      ${pkgs.vault-push-approles self}/bin/vault-push-approles
    '';

  vault-push-approle-envs = with pkgs;
    let
      p = pkgs.vault-push-approle-envs self {
        hostNameOverrides = {
          "amiya" = "208.87.130.175";
          "bonney" = "192.168.1.105";
          "gfdesk" = "192.168.1.122";
        };
      };
    in writeScriptBin "vault-push-approle-envs" ''
      ${p}/bin/vault-push-approle-envs
    '';

  push-vault-secrets = pkgs.writeScriptBin "push-vault-secrets" ''
    ${vault-push-approles}/bin/vault-push-approles && ${vault-push-approle-envs}/bin/vault-push-approle-envs
  '';
}

