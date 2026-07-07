{
  description = "Infra development progset";

  selector =
    pkgs:
    with pkgs;
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    [
      ansible
      backblaze-b2
      kubectl
      mqttui
      pixiecore
      podman-compose
      prettier
      pwgen
      qrencode
      qrrs
      whois
    ]
    ++ lib.optionals ps.stdenv.hostPlatform.isLinux [
      krb5
      ldapvi
      openldap
      qemu
      racket-minimal
    ];
}
