# Regular Vim configs, but with extra features enabled that make it more like an IDE.
{ self, ... }:
{ pkgs, ... }: {
  imports = [ self.homeModules.astrid_vi ];

  programs.neovim = {
    coc = {
      enable = true;
      settings = {
        "suggest.enablePreview" = true;
      };
    };

    extraConfig = builtins.readFile ./dotfiles/extra.nvim;

    plugins = with pkgs.vimPlugins; [
      vimtex
    ];
  };
}
