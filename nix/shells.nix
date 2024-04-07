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
      inetutils
      jq
      kubectl
      mqttui
      netcat
      nixfmt
      nodePackages.prettier
      pixiecore
      pwgen
      python3
      racket-minimal
      talosctl
      tcpdump
      terraform
      terraform-ls
      tftp-hpa
      tmux
      vault
      wget
      whois
      wireguard-tools
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

