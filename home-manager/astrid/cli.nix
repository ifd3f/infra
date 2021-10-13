# CLI-only home manager settings
{ pkgs, ... }:
let
  commonProfile = builtins.readFile ./dotfiles/.profile;

  commonAliases = {
    # Parent dirs
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # ls aliases
    "la" = "ls -A";
    "l" = "ls -CF";

    "ls" = "ls --color=auto";
    "dir" = "dir --color=auto";
    "vdir" = "vdir --color=auto";
    "grep" = "grep --color=auto";
    "fgrep" = "fgrep --color=auto";
    "egrep" = "egrep --color=auto";
  };
in {
  programs = {
    git = {
      enable = true;
      userName = "Astrid Yu";
      userEmail = "astrid@astrid.tech";
      extraConfig.init.defaultBranch = "main";
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
      initExtra = commonProfile;
    };

    bash = {
      enable = true;
      shellAliases = commonAliases;
      initExtra = commonProfile;
    };

    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    htop
    bitwarden-cli
    ranger
  ];

  home.file = {
    ".config/ranger/rc.conf" = { source = ./dotfiles/ranger.conf; };
    ".stack/config.yaml" = { source = ./dotfiles/stack-config.yaml; };
  };

  home.sessionVariables = { EDITOR = "nvim"; };
}
