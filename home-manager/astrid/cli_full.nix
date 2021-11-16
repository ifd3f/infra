# CLI-only home manager settings
{ self, ... }:
{ pkgs, ... }:
let
  calPolyUsername = "myu27";

  commonAliases = {
    "cal-poly-vpn" = "openconnect --protocol=gp cpvpn.calpoly.edu --user=${calPolyUsername}";
  };
in {
  imports = with self.homeModules; [
    nixos-vscode-server
    astrid_cli
    astrid_zsh;
  ];

  services = { vscode-server.enable = true; };

  home.file."email" = { source = ./email; };
  home.packages = with pkgs; [ 
    nixfmt
  ];
}
