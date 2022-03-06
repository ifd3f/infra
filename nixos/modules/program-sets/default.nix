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
      description = "Useful utilities for terminal environments";
      enableByDefault = true;
    })
    (mkProgset "x11" { description = "Utilities for working in X11"; })

    (mkProgset "browsers" { description = "Internet browsers"; })
    (mkProgset "cad" { description = "Computer-aided design software"; })
    (mkProgset "chat" { description = "Chat tools"; })
    (mkProgset "development" { description = "Development tools"; })
    (mkProgset "kbflash" { description = "Programs for flashing keyboards"; })
    (mkProgset "office" { description = "Office tools"; })
    (mkProgset "security" { description = "Security tools"; })

    (mkProgset "pc" { description = "Program pack for personal computers"; })
  ];
}
