{ self, nixpkgs-unstable }: let
  pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
  lib = pkgs.lib;

  home = map (name: {
    name = "home-manager-${name}";
    value = self.homeConfigurations."${name}".activationPackage;
  }) [
    "astrid@Discovery"
    "astrid@aliaconda"
    "astrid@banana"
    "astrid@shai-hulud"
  ];

  machines = map (name: {
    name = "nixos-${name}";
    value = self.nixosConfigurations."${name}".config.system.build.toplevel;
  }) [
    "banana"
    "donkey"
    "gfdesk"
    "shai-hulud"
  ];

  packages = map (name: {
    name = "package-${name}";
    value = self.packages.x86_64-linux."${name}";
  }) [
    "installer-iso"
  ];
in {
  x86_64-linux = builtins.listToAttrs (home ++ machines ++ packages);
}

