# My personal Vim configs, but a relatively minimal set of them.
{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-plug
      vim-sleuth
    ];
    extraConfig = 
      "source ${pkgs.vimPlugins.vim-plug}/plug.vim\n" + 
      builtins.readFile ./dotfiles/init.nvim
    ;
  };
}
