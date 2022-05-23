# X11-enabled home manager settings
{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ./xmonad
  ];

  options.astral.gui = {
    enable = mkOption {
      description = "Enable GUI customizations.";
      default = false;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.gui;
  in (mkIf cfg.enable (mkMerge [
    {
      nixpkgs.config.allowUnfree = true;

      programs = {
        firefox.enable = true;
        chromium.enable = true;
      };

      home.packages = with pkgs; [ xclip ];

      home.shellAliases = {
        # Pipe to/from clipboard
        "c" = "xclip -selection clipboard";
        "v" = "xclip -o -selection clipboard";
      };
    }
  ]));

}
