{ config, pkgs, ... }:

{
  home.username = "astrid";
  home.homeDirectory = "/home/astrid";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fzf
    htop
    starship
    neovim
    tmux
    ranger
  ];

  home.file.".local/state/hm_managed_packages" = {
    source =
      with pkgs;
      linkFarm "hm_managed_packages" [
        # TODO
        {
          name = "fzf";
          path = fzf;
        }
      ];
  };

  home.file.".local/share/nvim/site/pack" = {
    source =
      with pkgs.vimPlugins;
      pkgs.linkFarm "nvim_plugins" [
        {
          name = "plenary/start/plenary.nvim";
          path = plenary-nvim;
        }
        {
          name = "telescope/start/telescope.nvim";
          path = telescope-nvim;
        }
        {
          name = "telescope-fzf-native/start/telescope_fzf.nvim";
          path = telescope-fzf-native-nvim;
        }
        {
          name = "telescope_hoogle/start/telescope_hoogle.nvim";
          path = telescope_hoogle;
        }
        {
          name = "oil/start/oil.nvim";
          path = oil-nvim;
        }
      ];
  };
}
