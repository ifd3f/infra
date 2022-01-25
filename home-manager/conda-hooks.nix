{
  programs.bash.profileExtra = ''
    eval "$(/home/astrid/anaconda3/bin/conda shell.bash hook)" 
  '';

  programs.zsh.profileExtra = ''
    eval "$(/home/astrid/anaconda3/bin/conda shell.zsh hook)" 
  '';
}