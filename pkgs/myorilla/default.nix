{ rustPlatform, lib }:
let
  root = ../../.;
in
rustPlatform.buildRustPackage {
  pname = "myorilla";
  version = "0.1.0";

  src = lib.fileset.toSource {
    inherit root;
    fileset = lib.fileset.unions [
      ./.
      ../../Cargo.lock
      ../../Cargo.toml
    ];
  };

  cargoHash = "sha256-REOAczdKSqAPdenC/zBd7vPfvz0vvPkw+umjmiHm3BA=";
  cargoBuildFlags = [
    "--package=myorilla"
  ];
}
