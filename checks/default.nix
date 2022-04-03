{ self, nixpkgs-unstable }: let
  pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
  lib = pkgs.lib;

  home = map (name: {
    name = "01-can-build-home-manager-${name}";
    value = self.homeConfigurations."${name}".activationPackage;
  }) [
    "astrid@Discovery"
    "astrid@aliaconda"
    "astrid@banana"
    "astrid@shai-hulud"
  ];

  machines = map (name: {
    name = "00-can-build-nixos-machine-${name}";

    # Wrap as the input to a dummy derivation to prevent weird IFD issues
    value = pkgs.stdenv.mkDerivation {
      name = "dummy-to-prevent-ifd-for-nixos-machine-${name}";
      buildInputs = [ self.nixosConfigurations."${name}".config.system.build.toplevel ];
      phases = [];
    };
  }) [
    "banana"
    "donkey"
    "gfdesk"
    # it takes too long to recompile Linux
    # "shai-hulud"
  ];

  packages = map (name: {
    name = "02-can-build-package-${name}";
    value = self.packages.x86_64-linux."${name}";
  }) [
    "installer-iso"
  ];
in { x86_64-linux = builtins.listToAttrs (home ++ machines ++ packages); }

