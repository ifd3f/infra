{ self, inputs, ... }:
let
  modules = [
    # self.nixosModules.astral TODO 
    ./configuration.nix
    ({ modulesPath, ... }: {
      imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        "${modulesPath}/installer/cd-dvd/channel.nix"
      ];
    })
  ];
in
{
  _class = "flake";

  perSystem =
    { system, ... }:
    let
      os = inputs.nixpkgs-stable.lib.nixosSystem {
        inherit system modules;
      };
    in
    {
      packages.rescue = os.config.system.build.isoImage;
      #packages.rescue = os.config.system.build.netbootRamdisk;
    };
}
