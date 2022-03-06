{ pkgs, ... }: {
  astral.program-sets = {
    browsers = true;
  };

  environment.systemPackages = with pkgs; [
    cachix
    firefox-devedition-bin
    gh
    gitkraken
    imagemagick
    jetbrains.idea-ultimate
    nixfmt
    vscode-fhs
  ];
}
