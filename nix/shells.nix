{
  perSystem =
    {
      self',
      system,
      config,
      pkgs,
      ...
    }:
    let
      infraPackages =
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
          if system != "x86_64-darwin" then
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
      devShells = rec {
        infra = pkgs.mkShell {
          VAULT_ADDR = "https://secrets.astrid.tech";
          nativeBuildInputs = infraPackages;
        };

        default = infra;
      };
    };
}
