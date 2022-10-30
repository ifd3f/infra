{ self, lib }:
let
  home-linux = map (name: {
    name = "home-manager-${name}";
    value = self.homeConfigurations."${name}".activationPackage;
  }) [
    "astrid@Discovery"
    "astrid@aliaconda"
    "astrid@banana"
    "astrid@shai-hulud"
  ];

  home-macos = map (name: {
    name = "home-manager-${name}";
    value = self.homeConfigurations."${name}".activationPackage;
  }) [ "astrid@soulcaster" ];

  machines = map (name: {
    name = "nixos-${name}";
    value = self.nixosConfigurations."${name}".config.system.build.toplevel;
  }) [ "banana" "chungus" "donkey" "diluc" "gfdesk" "shai-hulud" ];

  aarch64-machines = map (name: {
    name = "nixos-${name}";
    value = self.nixosConfigurations."${name}".config.system.build.toplevel;
  }) [ "jonathan-js" "joseph-js" ];

  packages = map (name: {
    name = "package-${name}";
    value = self.packages.x86_64-linux."${name}";
  }) [ "installer-iso" ];

  shells = system:
    map (name: {
      name = "devShell-${name}";
      value = self.devShells.${system}."${name}";
    }) [ "default" "xmonad-dev" ];
in {
  x86_64-linux = builtins.listToAttrs
    (home-linux ++ machines ++ packages ++ (shells "x86_64-linux"));
  x86_64-darwin = builtins.listToAttrs (home-macos ++ (shells "x86_64-darwin"));
  # doesn't work rn ;(
  # aarch64-linux = builtins.listToAttrs aarch64-machines;
  aarch64-linux = { };
}

