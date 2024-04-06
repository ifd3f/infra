from typing import List


def make_firewall() -> List[str]:
    return [
        "delete firewall",
        "set firewall global-options state-policy established action 'accept'",
        "set firewall global-options state-policy related action 'accept'",
        "set firewall global-options state-policy invalid action 'accept'",
        "set firewall group ipv6-network-group dn42-allowed-transit-v6 network 'fd00::/8'",
        "set firewall group network-group dn42-allowed-transit-v4 network '10.0.0.0/8'",
        "set firewall group network-group dn42-allowed-transit-v4 network '172.20.0.0/14'",
        "set firewall group network-group dn42-allowed-transit-v4 network '172.31.0.0/16'",
        "set firewall group ipv6-network-group ifd3f-dn42-v6 network 'fd00:ca7:b015::/48'",
        "set firewall group network-group ifd3f-dn42-v4 network '172.23.7.176/28'",
    ]
