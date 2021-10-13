# CLI-only home manager settings
{ self, ... }:
{ pkgs, ... }:
let
  calPolyUsername = "myu27";

  commonAliases = {
    "cal-poly-vpn" = "openconnect --protocol=gp cpvpn.calpoly.edu --user=${calPolyUsername}";
  };
in {
  imports = [ 
    self.homeModules.nixos-vscode-server
    ./cli.nix
  ];

  services = { vscode-server.enable = true; };

  home.file."email" = { source = ./email; };
}
