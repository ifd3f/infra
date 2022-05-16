{ lib, nixpkgs, lxdUtils, convertImage, writeScriptBin, vendored-talos-os, gigarouterModule, flakeTime, pkgs }: let
  scripts = [
    (lxdUtils.writeVMUploader {
      name = "talos-os";
      alias = "talos/1.0.0/cloud";
      disk = convertImage {
        name = "talos-os";
        src = vendored-talos-os;
        inFmt = "raw";
      };
      metadata = {
        architecture = "amd64";
        creation_date = flakeTime;
        properties = {
          description = "Talos OS";
          os = "Talos";
          release = "1.0.0";
          type = "disk-kvm.img";
          variant = "cloud";
        };
      };
    })
    (lxdUtils.writeNixOSUploader {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      name = "gigarouter";
      modules = [ gigarouterModule ];
      alias = "gigarouter/1/cloud";
    })
  ];
in writeScriptBin "upload-all-to-lxd" (lib.concatMapStrings (x: "${x};") scripts)

