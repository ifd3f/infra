#!/usr/bin/env python3

import os
from typing import List, NamedTuple, Optional, Tuple

from .firewall import make_firewall

from . import dn42


def basic_setup() -> List[str]:
    return [
        "set interfaces ethernet eth0 address 'dhcp'",
        "set interfaces ethernet eth0 hw-id '52:54:00:40:30:53'",
        "set interfaces loopback lo",
        "set system console device ttyS0 speed '115200'",
        "set system host-name 'asmodeus'",
        "set system login user vyos authentication public-keys chungus key 'AAAAC3NzaC1lZDI1NTE5AAAAIEl4yuE1X4IqjBqt/enMyZFZKJQLxeq34BTCNqey59aZ'",
        "set system login user vyos authentication public-keys chungus type 'ssh-ed25519'",
        "set system name-server '8.8.8.8'",
        "set system name-server '8.8.4.4'",
        "set system syslog global facility all level 'info'",
        "set system syslog global facility local7 level 'debug'",
        "set protocols static route 0.0.0.0/0 next-hop 192.168.122.1",
        "set service ntp allow-client address '0.0.0.0/0'",
        "set service ntp allow-client address '::/0'",
        "set service ntp server time1.vyos.net",
        "set service ntp server time2.vyos.net",
        "set service ntp server time3.vyos.net",
        "set service ssh port '22'",
        "set system config-management commit-revisions '10000'",
        "set system conntrack modules ftp",
        "set system conntrack modules h323",
        "set system conntrack modules nfs",
        "set system conntrack modules pptp",
        "set system conntrack modules sip",
        "set system conntrack modules sqlnet",
        "set system conntrack modules tftp",
    ]


def main():
    cmds = []
    wg_privkey = os.environ["WG_PRIVKEY"]

    cmds += basic_setup()
    cmds += dn42.dn42_rpki()
    cmds += dn42.bgp_setup_configs()
    cmds += dn42.dn42_bgp_group()
    cmds += dn42.dn42_route_collector()
    cmds += dn42.dn42_wireguard_ll_peer(
        name="whojk",
        our_ll_address_cidr="fe80::1846/64",
        peer_ll_address="fe80::2717",
        peer_endpoint=("141.148.191.208", 24210),
        our_private_key=wg_privkey,
        peer_asn=4242422717,
        peer_pubkey="SpnH/BlVNDx5QiMxHhuF4i8hKr5qWMxnPYky6Mp4fEA=",
    )
    cmds += make_firewall()

    # extra commands
    cmds += [
        "set interfaces wireguard wg4242422717 address fd00:ca7:b015:7e57::7e57/64"
    ]

    for c in cmds:
        print(c)


if __name__ == "__main__":
    main()
