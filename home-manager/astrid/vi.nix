# My personal Vim configs, but a relatively minimal set of them.
{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = builtins.readFile ./dotfiles/init.nvim;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      vim-plug
    ];
  };
}
