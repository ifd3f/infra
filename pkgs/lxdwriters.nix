{ pkgs }:
rec {
  writeLXDMetadataTar = { lxdMetadataYaml }:
  pkgs.stdenv.mkDerivation {
    name = "metadata";
    src = pkgs.writeText "metadata.json" (builtins.toJSON lxdMetadataYaml);
    buildInputs = with pkgs; [ yq ];
    phases = [ "buildPhase" "installPhase" ];

    buildPhase = ''
      cd $TMPDIR
      cat $src | yq -y > metadata.yaml
      tar czvf lxd.tar.xz metadata.yaml
    '';

    installPhase = ''
      mkdir $out
      mv $TMPDIR/lxd.tar.xz $out
    '';
  };

  writeConvertedImage = { src, diskInputType ? "raw" }:
  pkgs.stdenv.mkDerivation {
    inherit src;
    name = "disk-from-${diskInputType}";
    phases = ["installPhase"];
    buildInputs = with pkgs; [ qemu ];
    installPhase = ''
      mkdir $out
      qemu-img convert -f '${diskInputType}' -O qcow2 $src $out/disk.qcow2
    '';
  };

  writeLXDFiles = { name, version, lxdMetadataYaml, disk }: pkgs.symlinkJoin {
    inherit name version;
    paths = [
      (writeLXDMetadataTar { inherit lxdMetadataYaml; })
      disk
    ];
  };
}
