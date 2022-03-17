# X11-enabled home manager settings
{ config, lib, pkgs, ... }:
with lib; {
  options.astral.macos = {
    enable = mkOption {
      description = "Enable MacOS-specific customizations.";
      default = false;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.macos;
  in (mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      powerline-fonts
      # iterm2 # needs to be compiled, takes too long
    ];
  });
}

