{ pkgs, ... }:
{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.astrid.shell = pkgs.zsh;
}
