# Settings for my customized zsh prompt.
{ powerlevel10k, ... }:
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    autocd = true;
    defaultKeymap = "emacs";

    history = {
      save = 1000000;
      size = 1000000;
      ignoreSpace = true;
      extended = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "ssh-agent" # Auto-start a SSH agent
      ];
    };

    initExtraBeforeCompInit = ''
      # Powerlevel10k configuration
      source ${./dotfiles/.p10k.zsh}

      # kubectl completion
      type kubectl > /dev/null && source <(kubectl completion zsh)

      # Do not load identities on start
      # See https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh-agent#settings
      zstyle :omz:plugins:ssh-agent lazy yes
    '';

    plugins = [{
      name = "powerlevel10k";
      file = "powerlevel10k.zsh-theme";
      src = powerlevel10k;
    }];
  };

  programs.ssh = {
    enable = true;
    extraOptionOverrides = {
      AddKeysToAgent = "yes";
    };
    includes = [ "config.d/*" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
}
