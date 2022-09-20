{ nixos-generators, pkgs }:
with pkgs; rec {
  writeVMMetaTar = { basename, metadata }:
    stdenvNoCC.mkDerivation {
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

  writeVMUploader = { name, disk, metadata, alias ? null }:
    let
      meta = writeVMMetaTar {
        inherit metadata;
        basename = name;
      };
      aliasFlag = if alias == null then "" else "--alias=${alias}";
    in writeScript "upload-${name}-to-lxd" ''
      lxc image import ${meta} ${disk} ${aliasFlag} $@
    '';

  writeNixOSUploader = { pkgs, name, modules, alias ? null }:
    let
      meta = nixos-generators.nixosGenerate {
        inherit pkgs modules;
        format = "lxc-metadata";
      };
      rootfs = nixos-generators.nixosGenerate {
        inherit pkgs modules;
        format = "lxc";
      };
      aliasFlag = if alias == null then "" else "--alias=${alias}";
    in writeScript "upload-${name}-to-lxd" ''
      lxc image import ${meta}/tarball/nixos-system-x86_64-linux.tar.xz ${rootfs}/tarball/nixos-system-x86_64-linux.tar.xz ${aliasFlag} $@
    '';
}

