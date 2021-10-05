# CLI-only home manager settings
{ pkgs, ... }:
let
  vscodeTarball = fetchTarball {
    url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
    sha256 = "sha256:14zqbjsm675ahhkdmpncsypxiyhc4c9kyhabpwf37q6qg73h8xz5";
  };

  commonAliases = {
    # Pipe to/from clipboard
    "c" = "xclip -selection clipboard";
    "v" = "xclip -o -selection clipboard";

    # Parent dirs
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # ls aliases
    "la" = "ls -A";
    "l" = "ls -CF";
  };
in
{
  imports = [
    "${vscodeTarball}/modules/vscode-server/home.nix"
  ];

  services = {
    vscode-server.enable = true;
  };

  programs = {
    git = {
      enable = true;
      userName = "Astrid Yu";
      userEmail = "astrid@astrid.tech";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };

    keychain = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableXsessionIntegration = true;
    };

    zsh = {
      enable = true;
      shellAliases = commonAliases;
    };

    bash = {
      enable = true;
      shellAliases = commonAliases;
    };

    neovim = {
      enable = true;
      coc.enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraConfig = builtins.readFile ./init.vim;
      plugins = with pkgs.vimPlugins; [
        nerdtree
      ];
    };

    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    htop
    bitwarden-cli
    ranger
  ];

  home.file = {
    ".stack/config.yaml" = {
      source = ./stack-config.yaml;
    };
    "email" = {
      source = ./email;
    };
  };

  home.sessionVariables = {
    EDITOR = "vi";
  };
}
