# A graphics-enabled laptop that I would directly use.
# Excludes laptops repurposed as headless servers.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inputs = config.astral.inputs;
in
{
  # imports = [ inputs.self.nixosModules.pc ];

  environment.systemPackages = with pkgs; [
    xorg.xf86videointel
    xorg.xf86inputsynaptics
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
