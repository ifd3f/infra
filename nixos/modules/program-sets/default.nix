# Standard program sets to enable or disable per-computer.
{ config, ... }: {
  imports = let
    mkProgsetModule =
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
    (mkProgsetModule "basics" {
      description = "Useful utilities for terminal environments";
      enableByDefault = true;
    })
    (mkProgsetModule "x11" { description = "Utilities for working in X11"; })

    (mkProgsetModule "browsers" { description = "Internet browsers"; })
    (mkProgsetModule "cad" { description = "Computer-aided design software"; })
    (mkProgsetModule "chat" { description = "Chat tools"; })
    (mkProgsetModule "dev" { description = "Development tools"; })
    (mkProgsetModule "office" { description = "Office tools"; })
    (mkProgsetModule "security" { description = "Security tools"; })
  ];
}
