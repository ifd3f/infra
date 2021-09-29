# CLI-only home manager settings
{ pkgs, ... }:
let vscodeTarball = fetchTarball {
  url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
  sha256 = "sha256:14zqbjsm675ahhkdmpncsypxiyhc4c9kyhabpwf37q6qg73h8xz5";
};
in
{
  imports = [
    "${vscodeTarball}/modules/vscode-server/home.nix"
  ];

  services = {
    vscode-server.enable = true;
  };

  programs = {
    git = {
      enable = true;
      userName = "Astrid Yu";
      userEmail = "astrid@astrid.tech";
    };

    keychain = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableXsessionIntegration = true;
    };

    zsh = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    htop
    bitwarden-cli
    ranger
  ];

  home.sessionVariables = {
    EDITOR = "vi";
  };
}
