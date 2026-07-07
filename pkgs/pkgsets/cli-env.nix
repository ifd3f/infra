{
  description = "Interactive CLI environment niceties";

  selector =
    ps: with ps; [
      direnv
      starship
      fzf
    ];
}
