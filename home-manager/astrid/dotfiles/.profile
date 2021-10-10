# Copy path of file to clipboard
function rlcp() {
    readlink -f $@ | c
}

# Zip versioned files
function gitzip() {
    git ls-files $2 --cached | xargs zip $1
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# This is not in the aliases property because it is too complex and takes too much escaping to make work.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

