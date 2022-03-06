{ nixos-hardware, qmk_firmware }:
{
  imports = [
    (import ./kb-flashing.nix { inherit qmk_firmware; })
    (import ./surface.nix { inherit nixos-hardware; })
  ];
}