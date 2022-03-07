{ pkgs, ... }: {
  astral.program-sets = { browsers = true; };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    android-studio
    cachix
    dbeaver
    firefox-devedition-bin
    gh
    gitkraken
    imagemagick
    jetbrains.idea-ultimate
    nixfmt
    vscode-fhs
  ];
}
