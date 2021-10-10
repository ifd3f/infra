# CLI-only home manager settings
{ pkgs, ... }:
let
  calPolyUsername = "myu27";

  vscodeTarball = fetchTarball {
    url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
    sha256 = "sha256:14zqbjsm675ahhkdmpncsypxiyhc4c9kyhabpwf37q6qg73h8xz5";
  };

  commonAliases = {
    "cal-poly-vpn" = "openconnect --protocol=gp cpvpn.calpoly.edu --user=${calPolyUsername}";
  };
in {
  imports = [ 
    "${vscodeTarball}/modules/vscode-server/home.nix"
    ./cli.nix
  ];

  services = { vscode-server.enable = true; };

  home.file."email" = { source = ./email; };
}
