{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nomacs
    xclip
    xev
  ];
}
