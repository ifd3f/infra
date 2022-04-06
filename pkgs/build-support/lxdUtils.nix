{ lxc, yq, stdenvNoCC, writeText, writeScript, ... }: rec {
  writeVMMetaTar = { basename, metadata }: stdenvNoCC.mkDerivation {
    name = "${basename}.tar.xz";

    src = writeText "metadata.json" (builtins.toJSON metadata);
    buildInputs = [ yq ];
    phases = [ "buildPhase" "installPhase" ];

    buildPhase = ''
      cd $TMPDIR
      yq . "$src" > metadata.yaml
      tar czvf lxd.tar.xz metadata.yaml
    '';

    installPhase = ''
      mv $TMPDIR/lxd.tar.xz $out
    '';
  };

  writeVMUploader = { name, disk, metadata, alias ? null }: let
    meta = writeVMMetaTar { inherit metadata; basename = name; };
    aliasFlag = if alias == null then "" else "--alias=${alias}";
  in writeScript "upload-${name}-to-lxd" ''
    lxc image import ${meta} ${disk} ${aliasFlag} $@
  '';
}

