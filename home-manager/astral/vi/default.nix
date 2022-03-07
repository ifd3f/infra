{ config, lib, pkgs, ... }:
with lib; {
  options.astral.vi = {
    enable = mkOption {
      description = "Enable neovim customizations.";
      default = true;
      type = types.bool;
    };

    ide = mkOption {
      description =
        "Enable extended neovim customizations to make it behave like an IDE.";
      default = false;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.vi;
  in mkIf cfg.enable (mkMerge [
    {
      programs.neovim = {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        plugins = with pkgs.vimPlugins; [ vim-plug vim-sleuth ];
        extraConfig = ''
          source ${pkgs.vimPlugins.vim-plug}/plug.vim
        '' + builtins.readFile ./init.nvim;
      };
    }
    (mkIf cfg.ide {
      programs.neovim = {
        coc = {
          enable = true;
          settings = { "suggest.enablePreview" = true; };
        };

        extraConfig = builtins.readFile ./ide.nvim;

        plugins = with pkgs.vimPlugins; [ vimtex ];
      };
    })
  ]);
}
