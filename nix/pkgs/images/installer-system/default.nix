{
  self,
  nixpkgs,
  system ? "x86_64-linux",
}:
{
  isoImage =
    (nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        (import ./configuration.nix self)

        (
          { modulesPath, ... }:
          {
            imports = [
              # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
              "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
              "${modulesPath}/installer/cd-dvd/channel.nix"
            ];
          }
        )
      ];
    }).config.system.build.isoImage;

  netbootRamdisk =
    (nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        (import ./configuration.nix self)

        (
          { modulesPath, ... }:
          {
            imports = [ "${modulesPath}/installer/netboot/netboot-minimal.nix" ];
          }
        )
      ];
    }).config.system.build.netbootRamdisk;
}
