# Direnv says to add to the end of your shell.
# https://direnv.net/docs/hook.html
if ! command -v direnv &> /dev/null; then
  echo "WARNING: direnv not found, not installing direnv hooks"
  return
fi

eval "$(direnv hook zsh)"
