{ stdenvNoCC, glibc, fetchzip, autoPatchelfHook }:
stdenvNoCC.mkDerivation {
  pname = "authelia-bin";
  version = "4.37.5";

  buildInputs = [ glibc ];
  nativeBuildInputs = [ autoPatchelfHook ];

  src = fetchzip {
    url =
      "https://github.com/authelia/authelia/releases/download/v4.37.5/authelia-v4.37.5-linux-amd64.tar.gz";
    sha256 = "sha256-2dkmzfkmM8QmnhrrALYVhRM943k07+ZSzZ8iHLYkhTU=";
    stripRoot = false;
  };

  installPhase = ''
    install -m755 -D $src/authelia-linux-amd64 $out/bin/authelia
  '';

  meta.mainProgram = "authelia";
}
