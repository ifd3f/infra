{ powerlevel10k }: {
  imports = [ (import ./cli { inherit powerlevel10k; }) ./vi ./gui ];
}
