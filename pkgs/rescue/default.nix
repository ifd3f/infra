{ nixos, baseModule }:
let
  os = nixos {
    imports = [
      baseModule
      ./configuration.nix
    ];
  };
in
os.config.system.build.isoImage
