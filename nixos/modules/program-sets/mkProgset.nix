# Create a progset module with the given name.
name:
{ enableByDefault ? false }:
config:
{ lib, ... }@inputs: {

  options.astral.program-sets."${name}" = with lib;
    mkOption {
      description = "Useful utilities for terminal environments.";
      default = enableByDefault;
      type = types.bool;
    };

  config = lib.mkIf config.astral.program-sets."${name}" config;
}
