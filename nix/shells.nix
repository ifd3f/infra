{ self, pkgs }:
let
  packages = with pkgs;
    with self.packages.${system};
    [
      ifd3f-infra-scripts

      (vault-push-approle-envs self)
      (vault-push-approles self)

      #ansible
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
      netcat
      nixfmt
      nodePackages.prettier
      pwgen
      python3
      step-ca
      step-cli
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
      ldapvi

      cdrkit
      iputils
      qemu
    ] else
      [ ]);
in {
  default = pkgs.mkShell {
    nativeBuildInputs = packages;
    VAULT_ADDR = "https://secrets.astrid.tech";
  };
}

