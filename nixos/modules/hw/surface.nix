{ nixos-hardware }:
{ config, lib, ... }:
with lib; {
  options.astral.hw.surface.enable = mkOption {
    description = ''
      Enable standard Surface Pro configs

      Also see https://github.com/NixOS/nixos-hardware/tree/master/microsoft/surface
    '';
    default = false;
    type = types.bool;
  };

  # TODO
}
