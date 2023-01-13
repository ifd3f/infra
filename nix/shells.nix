{ self, pkgs }:
let
  packages = with pkgs;
    with self.packages.${system};
    [
      ifd3f-infra-scripts

      ansible
      backblaze-b2
      bitwarden-cli
      curl
      dnsutils
      docker
      docker-compose
      git
      helmfile
      inetutils
      jq
      ldapvi
      netcat
      nixfmt
      nodePackages.prettier
      python3
      tcpdump
      terraform
      terraform-ls
      tmux
      vault
      wget
      whois
      yq
    ] ++ (if pkgs.system != "x86_64-darwin" then [
      openldap
      krb5
      sssd

      cdrkit
      iputils
      qemu
    ] else
      [ ]);
in {
  default = pkgs.mkShell { nativeBuildInputs = packages; };
}

