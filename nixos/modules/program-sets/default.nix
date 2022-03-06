# Standard program sets to enable or disable per-computer.
{ config, ... }: {
  imports = let
    mkProgset =
      # Helper to create a progset module with the given name.
      name:
      { description, enableByDefault ? false }:
      { pkgs, lib, ... }@inputs: {
        options.astral.program-sets."${name}" = with lib;
          mkOption {
            inherit description;
            default = enableByDefault;
            type = types.bool;
          };

        config = lib.mkIf config.astral.program-sets."${name}"
          (import (./. + "/${name}.nix") inputs);
      };
  in [
    (mkProgset "basics" {
      description = "Useful utilities for terminal environments.";
      enableByDefault = true;
    })
  ];
}
