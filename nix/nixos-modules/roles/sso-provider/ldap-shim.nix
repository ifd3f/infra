# Since Keycloak seems to really hate LDAP over IPv6, we'll use
# 6tunnel to translate.

{ pkgs, ... }: {
  systemd.services.kc-ldap-shim = {
    description = "Shim between Keycloak (IPv4) and Central LDAP (IPv6)";

    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    path = with pkgs; [ socat ];
    script = ''
      socat TCP4-LISTEN:636,fork TCP6:ipa0.id.astrid.tech:636
    '';
  };
}
