# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1
export TERM="xterm-256color"

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
# bindkey -v

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Environment variables
source ~/.profile

# History search
autoload -Uz history-beginning-search-menu
zle -N history-beginning-search-menu
bindkey '^X^X' history-beginning-search-menu

# Powerlevel9k
source /usr/share/powerlevel9k/powerlevel9k.zsh-theme
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND=039 
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='white'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=213
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='white'
POWERLEVEL9K_DIR_HOME_BACKGROUND=213
POWERLEVEL9K_DIR_HOME_FOREGROUND='white'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=213
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='white'

POWERLEVEL9K_STATUS_OK_BACKGROUND='white'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND=165
POWERLEVEL9K_HISTORY_BACKGROUND=213
POWERLEVEL9K_HISTORY_FOREGROUND='white'
POWERLEVEL9K_TIME_BACKGROUND=039
POWERLEVEL9K_TIME_FOREGROUND='white'

POWERLEVEL9K_VCS_CLEAN_BACKGROUND='white'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='white'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='white'

POWERLEVEL9K_DISABLE_PROMPT=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs vcs history time)

# LS_COLORS
. ~/.local/share/lscolors.sh

# NVM script
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
[ -f "/home/astrid/.ghcup/env" ] && source "/home/astrid/.ghcup/env" # ghcup-env

. ~/.aliases

eval $(thefuck --alias)
