# A role representing a laptop.
{ pkgs, lib, ... }:
with lib; {
  options.astral.roles.laptop = mkOption {
    description = "Laptop";
    default = false;
    type = types.bool;
  };

  config = {
    environment.systemPackages = with pkgs; [
      xorg.xf86videointel
      xorg.xf86inputsynaptics
    ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  };
}
