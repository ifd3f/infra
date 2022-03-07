# A role representing a laptop.
{ config, pkgs, lib, ... }:
with lib; {
  options.astral.roles.laptop.enable = mkOption {
    description = "Laptop";
    default = false;
    type = types.bool;
  };

  config = mkIf config.astral.roles.laptop.enable {
    environment.systemPackages = with pkgs; [
      xorg.xf86videointel
      xorg.xf86inputsynaptics
    ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  };
}
