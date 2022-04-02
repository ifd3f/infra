{ pkgs }:
let
  utils = import ./utils.nix { inherit pkgs; };
  talos-os = with utils; writeLXDFiles {
    name = "talos-os";
    version = "1.0.0";

    lxdMetadataYaml = {
      architecture = "x86-64";
      creation_data = 123567445;
      properties = {
        description = "Talos OS";
        os = "Linux";
        release = "1.0.0";
      };
    };

    disk = writeConvertedImage {
      src = pkgs.fetchurl {
        url = "https://github.com/siderolabs/talos/releases/download/v1.0.0/talos-amd64.iso";
        sha256 = "sha256-UiyVJzhceKDtpebSoLVdr9tbh6OAxuG8QsBIDjJE8qg=";
      };
    };
  };

  simplestreams = pkgs.stdenv.mkDerivation {
    name = "internal-simplestreams";
    buildInputs = with pkgs; [ nginx lxd-image-server ];

    LXD_IMAGE_SERVER_CONFIG = pkgs.writeText "config.toml" ''
      [logging.handlers.filelog]
        level = "INFO"
        class = "logging.FileHandler"
        filename = "/build/var/log/lxd-image-server/lxd-image-server.log"
        formatter = "complex"
    '';

    phases = ["installPhase"];

    installPhase = ''
      mkdir -p /build/var/log/lxd-image-server
      mkdir -p $out/var/www/simplestreams

      lxd-image-server init \
        --root_dir $out/var/www/simplestreams

      export TALOS_DIR=$out/var/www/simplestreams/images/talos-os/1.0.0/amd64/default/20220402_01:27

      mkdir -p $TALOS_DIR

      # cp -r ${talos-os}/* $TALOS_DIR
      ln -s ${talos-os}/lxd.tar.xz $TALOS_DIR
      ln -s ${talos-os}/disk.qcow2 $TALOS_DIR

      lxd-image-server update \
        --img_dir $out/var/www/simplestreams/images \
        --streams_dir $out/var/www/simplestreams/streams/v1
      lxd-image-server update \
        --img_dir $out/var/www/simplestreams/images \
        --streams_dir $out/var/www/simplestreams/streams/v1
    '';

    meta.systems = [ "x86_64-linux" ];
  };

in simplestreams

