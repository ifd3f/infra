{ nixpkgs, astralModule, home-manager }:
{ config, hostName, domain ? "id.astrid.tech" }:
nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
     {
    inherit hostName;
    domain = "id.astrid.tech";
     }
    astralModule
    config
  ];
}
