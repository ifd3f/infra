# CLI-only home manager settings
{ powerlevel10k }:
{ config, lib, pkgs, ... }:
let commonProfile = builtins.readFile ./.profile;
in with lib; {
  imports = [ ./conda-hooks.nix ];

  options.astral.cli = {
    enable = mkOption {
      description = "Enable basic CLI customizations.";
      default = true;
      type = types.bool;
    };

    extended = mkOption {
      description = "Enable extended CLI customizations.";
      default = false;
      type = types.bool;
    };
  };

  config = let
    cfg = config.astral.cli;
    commonAliases = (mkIf cfg.enable (mkMerge [
      {
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
      }

      (mkIf cfg.extended {
        "cal-poly-vpn" =
          "openconnect --protocol=gp cpvpn.calpoly.edu --user=myu27";
      })
    ]));
  in mkIf cfg.enable (mkMerge [
    {
      home = {
        shellAliases = commonAliases;
        sessionVariables = { EDITOR = "vi"; };
        packages = with pkgs; [ htop home-manager bitwarden-cli ranger ];
        file = {
          ".config/ranger/rc.conf" = { source = ./ranger.conf; };
          ".stack/config.yaml" = { source = ./stack-config.yaml; };
        };
      };

      programs.git = {
        enable = true;
        userName = "Astrid Yu";
        userEmail = "astrid@astrid.tech";
        extraConfig = {
          init.defaultBranch = "main";
          credential.helper = "store";
          core.autocrlf = "input";
        };
      };

      programs.tmux = {
        enable = true;
        clock24 = true;
        keyMode = "vi";
        terminal = "screen-256color";
        historyLimit = 10000;
        newSession = true;
      };

      programs.zsh = {
        enable = true;
        initExtra = commonProfile;
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
          source ${./.p10k.zsh}

          # kubectl completion
          type kubectl > /dev/null && source <(kubectl completion zsh)

          # Do not load identities on start
          # See https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh-agent#settings
          zstyle :omz:plugins:ssh-agent lazy yes

          # Potentially needed on non-NixOS
          export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}
        '';

        plugins = [{
          name = "powerlevel10k";
          file = "powerlevel10k.zsh-theme";
          src = powerlevel10k;
        }];
      };

      programs.bash = {
        enable = true;
        initExtra = commonProfile;
      };

      programs.ssh = {
        enable = true;
        extraOptionOverrides = { AddKeysToAgent = "yes"; };
        includes = [ "config.d/*" ];
      };
    }

    (mkIf cfg.extended {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        tmux.enableShellIntegration = true;
      };

      programs.gpg = {
        enable = true;
        mutableKeys = true;
      };
    })
  ]);
  # home.file."email" = { source = ./email; };
}
