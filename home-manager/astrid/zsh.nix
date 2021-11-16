# Settings for my customized zsh prompt.
{ powerlevel10k, ... }:
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    history = {
      save = 1000000;
      size = 1000000;
      ignoreSpace = true;
      extended = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    initExtra = ''
      # Powerlevel10k sourcing
      source ${./dotfiles/.p10k.zsh}
    '';

    plugins = [{
      name = "powerlevel10k";
      file = "powerlevel10k.zsh-theme";
      src = powerlevel10k;
    }];
  };
}
