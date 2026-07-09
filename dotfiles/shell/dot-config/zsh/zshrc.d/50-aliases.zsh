# Create session 'main' or attach to 'main' if already exists.
alias "tmain"="tmux new-session -A -s main"

# Parent dirs
alias ".."="..";
alias "..."="../..";
alias "...."="../../..";

# ls aliases
alias "l"="ls -CF";
alias "la"="ls -A";
alias "ll"="ls -la";

# Automatically use colors
alias "ls"="ls --color=auto";
alias "dir"="dir --color=auto";
alias "vdir"="vdir --color=auto";
alias "grep"="grep --color=auto";
alias "fgrep"="fgrep --color=auto";
alias "egrep"="egrep --color=auto";

# Automatically set BW_SESSION
# alias "bwlogin"="export BW_SESSION=$(bw unlock --raw)";

