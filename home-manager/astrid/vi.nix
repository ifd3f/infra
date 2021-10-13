# My personal Vim configs
{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    coc.enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = builtins.readFile ./dotfiles/init.vim;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      vim-plug
      vimtex
    ];
  };
}
