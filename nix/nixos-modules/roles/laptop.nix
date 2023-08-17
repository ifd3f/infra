# A graphics-enabled laptop that I would directly use.
# Excludes laptops repurposed as headless servers.
inputs:
{ config, pkgs, lib, ... }: {
  imports = [ inputs.self.nixosModules.pc ];

  environment.systemPackages = with pkgs; [
    xorg.xf86videointel
    xorg.xf86inputsynaptics
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
