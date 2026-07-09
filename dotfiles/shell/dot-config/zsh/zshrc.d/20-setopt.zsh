# Enable completions
autoload -Uz compinit && compinit

# cd recent
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert always

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

# emacs-style keybindings
bindkey -e

