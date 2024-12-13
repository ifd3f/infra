{ stdenv, python3, makeWrapper, writeText, version, config }:
let
  configFile =
    writeText "vfiohotplug-config-${version}" (builtins.toJSON config);
  vfiohotplug = stdenv.mkDerivation rec {
    pname = "vfiohotplug";
    inherit version;
    nativeBuildInputs = [ makeWrapper ];
    propagatedBuildInputs = [ python3 ];
    dontUnpack = true;
    installPhase = ''
      install -Dm755 ${./vfiohotplug.py} $out/bin/${pname}
    '';
    postFixup = ''
      wrapProgram $out/bin/${pname} \
        --set VFIOHOTPLUG_CONFIG_PATH ${configFile}
    '';
  };
in vfiohotplug
