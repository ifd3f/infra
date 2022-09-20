# Copy path of file to clipboard
function rlcp() {
    readlink -f $@ | tr -d '\n' | xclip -selection clipboard
}
