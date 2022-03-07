# X11-enabled home manager settings
{ config, lib, pkgs, ... }:
with lib; {
  imports = [ ./alacritty.nix ];

  options.astral.cli = {
    enable = mkOption {
      description = "Enable basic GUI customizations.";
      default = true;
      type = types.bool;
    };

    alacritty.enable = mkOption {
      description = "Enable alacritty customizations.";
      default = false;
      type = types.bool;
    };
  };

  config = let cfg = options.astral.gui;
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

    (mkIf cfg.alacritty.enable {
      home.packages = [ meslo-lgs-nf ];

      programs.alacritty = {
        enable = true;
        settings = {
          font = {
            size = 9;
            normal.family = "MesloLGS NF";
          };
        };
      };
    })
  ]));

}
