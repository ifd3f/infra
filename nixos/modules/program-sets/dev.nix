{ pkgs, ... }: {
  astral.program-sets = { browsers = true; };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    android-studio
    cachix
    firefox-devedition-bin
    gh
    gitkraken
    imagemagick
    jetbrains.idea-ultimate
    nixfmt
    vagrant
    vscode-fhs
  ];
}
