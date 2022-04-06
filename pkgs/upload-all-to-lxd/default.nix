{ lib, lxdUtils, convertImage, writeScriptBin, vendored-talos-os, vendored-centos-8-cloud, flakeTime }: let
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
    (lxdUtils.writeVMUploader {
      name = "centos-8-cloud";
      alias = "centos/8-Stream/cloud-nolxd";
      disk = vendored-centos-8-cloud;
      metadata = {
        architecture = "amd64";
        creation_date = flakeTime;
        properties = {
          description = "Centos 8";
          os = "Centos";
          release = "8-Stream";
          type = "disk-kvm.img";
          variant = "cloud";
        };
      };
    })
    /* (lxdUtils.writeVMUploader {
      name = "gigarouter";
      alias = "nixos/unstable/astral-gigarouter";
      disk = gigarouter-image;
      metadata = {
        architecture = "amd64";
        creation_date = flakeTime;
        properties = {
          description = "NixOS Unstable";
          os = "NixOS";
          release = "unstable";
          type = "disk-kvm.img";
          variant = "astral-gigarouter";
        };
      };
    }) */
  ];
in writeScriptBin "upload-all-to-lxd" (lib.concatMapStrings (x: "${x};") scripts)

