{ stdenv, lib, callPackage, fetchurl, jq, writeScriptBin
, writeLXDMetadataTar, writeConvertedImage, writeLXDFiles
, lxd-image-server, writeText, flakeTime }:
let
  images = {
    "talos-os/1.0.0/amd64/default" = writeLXDFiles {
      name = "talos-os";
      version = "1.0.0";

      lxdMetadataYaml = {
        architecture = "x86-64";
        creation_data = flakeTime;
        properties = {
          description = "Talos OS";
          os = "Linux";
          release = "1.0.0";
        };
      };

      disk = writeConvertedImage {
        src = fetchurl {
          url = "https://github.com/siderolabs/talos/releases/download/v1.0.0/talos-amd64.iso";
          sha256 = "sha256-UiyVJzhceKDtpebSoLVdr9tbh6OAxuG8QsBIDjJE8qg=";
        };
      };
    };
  };

  flakeTimeStr = builtins.toString flakeTime;

  linkImagesScript = writeScriptBin "linkImages" (lib.concatStringsSep "\n" ([
    "subfolder=$(date -d @${flakeTimeStr} '+%Y%M%d_%H:%m')"
  ] ++ lib.mapAttrsToList (subpath: deriv: ''
    folder="$out/images/${subpath}/$subfolder"
    mkdir -p $folder
    for file in $(ls ${deriv}); do
      srcpath="${deriv}/$file"
      ln -sv $srcpath $folder
    done
  '') images));
in stdenv.mkDerivation {
  pname = "internal-lxd-simplestreams-tree";
  version = flakeTimeStr;

  buildInputs = [ lxd-image-server linkImagesScript jq ] ++ lib.attrValues images;

  LXD_IMAGE_SERVER_CONFIG = writeText "config.toml" ''
    [logging.handlers.filelog]
    level = "INFO"
    class = "logging.FileHandler"
    filename = "/build/log/lxd-image-server.log"
    formatter = "complex"
  '';

  phases = ["installPhase" "fixupPhase"];

  installPhase = ''
    mkdir -p /build/log
    mkdir -p $out/images $out/streams/v1

    lxd-image-server init --root_dir $out

    linkImages

    lxd-image-server update --img_dir $out/images --streams_dir $out/streams/v1
  '';

  fixupPhase = ''
    # Fixup the manifest's last updated time
    jq --argjson t ${flakeTimeStr} '.last_update = $t' $out/streams/v1/images.json > $TMP/tmp.json
    mv $TMP/tmp.json $out/streams/v1/images.json
  '';

  meta.systems = [ "x86_64-linux" ];
}

