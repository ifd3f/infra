{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.astral.inputs =
    with lib;
    mkOption {
      description = "The infra repo's flake input";
      type = types.attrs;
    };
}
