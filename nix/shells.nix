{ self, pkgs }:
let
  packages =
    with pkgs;
    [
      ansible
      backblaze-b2
      curl
      dnsutils
      git
      inetutils
      jq
      kubectl
      mqttui
      netcat
      nixfmt-rfc-style
      nodePackages.prettier
      pixiecore
      podman-compose
      pwgen
      python3
      racket-minimal
      talosctl
      tcpdump
      tmux
      wget
      whois
      wireguard-tools
      yq
    ]
    ++ (
      if pkgs.system != "x86_64-darwin" then
        [
          openldap
          krb5
          ldapvi

          cdrkit
          iputils
          qemu
        ]
      else
        [ ]
    );
in
{
  default = pkgs.mkShell {
    nativeBuildInputs = packages;
    VAULT_ADDR = "https://secrets.astrid.tech";
  };
}
