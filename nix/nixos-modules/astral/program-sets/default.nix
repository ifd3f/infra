# Standard program sets to enable or disable per-computer.
let
  wrapPS =
    {
      name,
      description,
      progFn,
      enableByDefault ? false,
    }:
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.astral.program-sets."${name}" =
        with lib;
        mkOption {
          inherit description;
          default = enableByDefault;
          type = types.bool;
        };

      config = lib.mkIf config.astral.program-sets."${name}" (progFn {
        inherit pkgs;
      });
    };
in
{
  imports = map wrapPS [
    (import ./basics.nix)
    (import ./x11.nix)

    (import ./browsers.nix)
    (import ./cad.nix)
    (import ./chat.nix)
    (import ./dev.nix)
    (import ./office.nix)
    (import ./security.nix)
  ];
}
