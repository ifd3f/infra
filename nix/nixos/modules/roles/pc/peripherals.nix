{ pkgs, inputs, ... }:
{
  imports = [
    "${inputs.self}/nix/nixos/modules/peripherals/keyboards.nix"
    "${inputs.self}/nix/nixos/modules/peripherals/logitech-unifying.nix"
    "${inputs.self}/nix/nixos/modules/peripherals/radios.nix"
    "${inputs.self}/nix/nixos/modules/peripherals/smart-cards.nix"
  ];

  # mounting various peripheral filesystems
  services.gvfs.enable = true;

  # printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
    ];
  };

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
