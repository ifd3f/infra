{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    ansible
    backblaze-b2
    bitwarden-cli
    curl
    dnsutils
    docker
    docker-compose
    gh
    git
    google-cloud-sdk
    helmfile
    jq
    kubectl
    kubernetes-helm
    minikube
    mysql80
    neovim
    netcat
    nixfmt
    nodePackages.prettier
    # oci-cli
    packer
    postgresql
    python3
    tcpdump
    terraform
    wget
    whois
    yq
  ] ++ (
    if pkgs.system != "x86_64-darwin"
      then [ iputils ]
      else []
  );
}
