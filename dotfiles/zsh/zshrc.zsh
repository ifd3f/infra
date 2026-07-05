# Open directly into tmux
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   # Create session 'main' or attach to 'main' if already exists.
#   tmux new-session -A -s main
# fi

# Create session 'main' or attach to 'main' if already exists.
alias "tmain"="tmux new-session -A -s main"

# Enable starship
eval "$(starship init zsh)"

# If you "execute" a directory, it CD's into the directory
setopt AUTO_CD
# `cd` stores a history onto a stack that you can then `popd` to return to
setopt AUTO_PUSHD

# Write timestamps
setopt EXTENDED_HISTORY
# Append to history immediately after running commands
setopt INC_APPEND_HISTORY
# Share history between shells
setopt SHARE_HISTORY

# Potentially needed nix path settings on non-NixOS
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}

# This is set in my home-manager config as a nice place to import various packages from
export HM_MANAGED_PACKAGES=$HOME/.local/state/hm_managed_packages

# Default editor for other commands
export EDITOR=vi

# emacs-style keybindings
bindkey -e

# Enable completions
autoload -Uz compinit && compinit

# cd recent
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert always

# Parent dirs
alias ".."="..";
alias "..."="../..";
alias "...."="../../..";

# ls aliases
alias "la"="ls -A";
alias "l"="ls -CF";

# Automatically use colors
alias "ls"="ls --color=auto";
alias "dir"="dir --color=auto";
alias "vdir"="vdir --color=auto";
alias "grep"="grep --color=auto";
alias "fgrep"="fgrep --color=auto";
alias "egrep"="egrep --color=auto";

# Automatically set BW_SESSION
# alias "bwlogin"="export BW_SESSION=$(bw unlock --raw)";

# Set up direnv
eval "$(direnv hook zsh)"
