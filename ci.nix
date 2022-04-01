# CI jobs that run on x86_64-linux
{ stdenv, self }: let
  home = map (name: self.homeConfigurations."${name}".activationPackage) [
    "astrid@Discovery"
    "astrid@aliaconda"
    "astrid@banana"
    # "astrid@shai-hulud" it takes too long to compile Linux
  ];
  nixos = map (name: self.nixosConfigurations."${name}".config.system.build.toplevel) [
    "banana"
    "donkey"
    "gfdesk"
    "shai-hulud"
  ];
  packages = map (name: self.packages.x86_64-linux."${name}") [ "installer-iso" ];
in
stdenv.mkDerivation {
  name = "astralbijection-ci";
  buildInputs = home ++ nixos ++ packages;
}

