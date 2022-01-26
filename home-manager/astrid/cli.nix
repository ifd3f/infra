# CLI-only home manager settings
{ pkgs, ... }:
let
  commonProfile = builtins.readFile ./dotfiles/.profile;
in {
  home.shellAliases = {
    # Parent dirs
    ".." = "..";
    "..." = "../..";
    "...." = "../../..";

    # ls aliases
    "la" = "ls -A";
    "l" = "ls -CF";

    # Automatically use colors
    "ls" = "ls --color=auto";
    "dir" = "dir --color=auto";
    "vdir" = "vdir --color=auto";
    "grep" = "grep --color=auto";
    "fgrep" = "fgrep --color=auto";
    "egrep" = "egrep --color=auto";

    # Automatically set BW_SESSION
    "bwlogin" = "export BW_SESSION=$(bw unlock --raw)";
  };

  programs = {
    git = {
      enable = true;
      userName = "Astrid Yu";
      userEmail = "astrid@astrid.tech";
      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "store";
        core.autocrlf = "input";
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      terminal = "screen-256color";
      historyLimit = 10000;
      newSession = true;
    };

    zsh = {
      enable = true;
      initExtra = commonProfile;
    };

    bash = {
      enable = true;
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
