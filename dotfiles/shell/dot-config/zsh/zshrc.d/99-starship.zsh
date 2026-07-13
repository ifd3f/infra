# Starship says to add to the end of the configuration.
if ! command -v starship &> /dev/null; then
  echo "WARNING: starship not installed, not setting it up"
  return
fi

eval "$(starship init zsh)"
