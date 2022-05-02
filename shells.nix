{ pkgs ? import <nixpkgs> { } }:
let
  packages = with pkgs; [
    ansible
    backblaze-b2
    bitwarden-cli
    cdrkit
    curl
    dnsutils
    docker
    docker-compose
    gh
    git
    helmfile
    jq
    kubectl
    kubernetes-helm
    netcat
    nixfmt
    nixops
    nodePackages.prettier
    packer
    python3
    tcpdump
    terraform
    terraform-ls
    wget
    whois
    yq

    nur.repos.astralbijection.talosctl
  ] ++ (
    if pkgs.system != "x86_64-darwin"
    then [ iputils ]
    else []
  );
in {
  default = pkgs.mkShell {
    nativeBuildInputs = packages;
  };
}

