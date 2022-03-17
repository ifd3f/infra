# X11-enabled home manager settings
{ config, lib, pkgs, ... }:
with lib; {
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
    {
      home.packages = with pkgs; [ meslo-lgs-nf ];

      programs.alacritty = {
        enable = true;
        settings = {
          font = {
            size = 9;
            normal.family = "MesloLGS NF";
          };
        };
      };
    }
  ]));

}
