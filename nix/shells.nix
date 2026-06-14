{ self, pkgs }:
let
  packages =
    with pkgs;
    [
      age
      ansible
      backblaze-b2
      black
      curl
      dnsutils
      git
      inetutils
      jq
      kubectl
      mqttui
      netcat
      nixfmt
      openssl
      pixiecore
      podman-compose
      prettier
      pwgen
      python3
      qrencode
      qrrs
      racket-minimal
      talosctl
      tcpdump
      tmux
      wget
      whois
      wireguard-tools
      yq
      yubikey-manager
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
