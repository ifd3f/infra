# Converts image formats using qemu.
{ stdenv, pkgs, qemu, ... }:
{ name, src, inFmt, outFmt ? "qcow2" }:
stdenv.mkDerivation {
  inherit name src;
  phases = [ "buildPhase" "installPhase" ];
  buildInputs = [ qemu ];

  buildPhase = ''
    qemu-img convert -f '${inFmt}' -O ${outFmt} $src $TMPDIR/disk.qcow2
  '';

  installPhase = ''
    qemu-img convert -f '${inFmt}' -O ${outFmt} $src $out
  '';
}

