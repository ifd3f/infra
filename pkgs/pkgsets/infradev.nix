{
  name = "Infra development progset";

  selector =
    pkgs:
    with pkgs;
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    [
      age
      ansible
      backblaze-b2
      black
      curl
      dnsutils
      git
      inetutils
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
      if system != "x86_64-darwin" then
        [
          cdrkit
          iputils
          krb5
          ldapvi
          openldap
          qemu
        ]
      else
        [ ]
    );
}
