{ pkgs, ... }: {
  astral.program-sets = {
    browsers = true;
  };

  environment.systemPackages = with pkgs; [
    firefox-devedition-bin
    gh
    gitkraken
    imagemagick
    jetbrains.idea-ultimate
    nixfmt
    vscode-fhs
  ];
}
