from typing import List, Optional, Tuple

from .utils import WireguardTunnel, LinkLocalBgpPeer, WireguardPeer

ROUTE_MAP_DN42_ROA = "dn42-roa"


def bgp_setup_configs() -> List[str]:
    return [
        "set protocols bgp parameters router-id '172.23.7.177'",
        "set protocols bgp system-as '4242421846'",
        "set protocols bgp address-family ipv4-unicast network 172.23.7.176/28",
        "set protocols bgp address-family ipv6-unicast network fd00:ca7:b015::/48",
    ]


def dn42_bgp_group() -> List[str]:
    cmds = [
        "delete protocols bgp peer-group dn42",
        "set protocols bgp peer-group dn42 capability extended-nexthop",
    ]

    for af in ["ipv4-unicast", "ipv6-unicast"]:
        cmds += [
            f"set protocols bgp peer-group dn42 address-family {af} route-map export {ROUTE_MAP_DN42_ROA}",
            f"set protocols bgp peer-group dn42 address-family {af} route-map import {ROUTE_MAP_DN42_ROA}",
            f"set protocols bgp peer-group dn42 address-family {af} soft-reconfiguration inbound",
        ]

    return cmds


def dn42_wireguard_ll_peer(
    *,
    name: str,
    our_ll_address_cidr: str,
    our_private_key: str,
    our_endpoint_port: Optional[int] = None,
    peer_ll_address: str,
    peer_asn: int,
    peer_pubkey: int,
    peer_endpoint: Optional[Tuple[str, int]] = None,
) -> List[str]:
    ifname = f"wg{peer_asn}"

    tunnel = WireguardTunnel(
        ifname=ifname,
        our_address_cidr=our_ll_address_cidr,
        our_private_key=our_private_key,
        our_endpoint_port=our_endpoint_port,
        description=f"'dn42 peering tunnel for {name} (AS{peer_asn})'",
        peers=[
            WireguardPeer(
                name=name,
                endpoint=peer_endpoint,
                public_key=peer_pubkey,
            )
        ],
    )

    bgp = LinkLocalBgpPeer(
        ifname=ifname,
        description=f"'dn42 peer {name} (AS{peer_asn})'",
        peer_address=peer_ll_address,
        peer_asn=peer_asn,
        peer_group="dn42",
    )

    return tunnel.render() + bgp.render()


def dn42_route_collector():
    addr = "fd42:4242:2601:ac12::1"
    return [
        f"delete policy route-map Deny-All",
        f"set policy route-map Deny-All rule 1 action deny",
        f"delete protocols bgp neighbor {addr}",
        f"set protocols bgp neighbor {addr} address-family ipv4-unicast route-map import 'Deny-All'",
        f"set protocols bgp neighbor {addr} address-family ipv6-unicast route-map import 'Deny-All'",
        f"set protocols bgp neighbor {addr} description 'https://lg.collector.dn42'",
        f"set protocols bgp neighbor {addr} ebgp-multihop '10'",
        f"set protocols bgp neighbor {addr} remote-as '4242422602'",
    ]


def dn42_rpki(nat_rulenum: int = 10):
    container_addr = "172.16.2.10"
    subnet = "172.16.2.0/24"
    port = 8082

    cmds = []

    # use the gortr container
    cmds += [
        "delete container name gortr",
        "delete container network rpki",
        "set container name gortr image 'cloudflare/gortr'",
        "set container name gortr restart 'on-failure'",
        f"set container name gortr command '-cache https://dn42.burble.com/roa/dn42_roa_46.json -verify=false -checktime=false -bind :{port}'",
        f"set container name gortr network rpki address '{container_addr}'",
        f"set container network rpki prefix '{subnet}'",
    ]

    # NAT the container network
    cmds += [
        f"delete nat source rule {nat_rulenum}"
        f"set nat source rule {nat_rulenum} outbound-interface name 'eth0'",
        f"set nat source rule {nat_rulenum} translation address 'masquerade'",
        f"set nat source rule {nat_rulenum} source address '{subnet}'",
    ]

    # Point at rpki
    cmds += [
        f"set protocols rpki cache {container_addr} port {port}",
        f"set protocols rpki cache {container_addr} preference 1",
    ]

    cmds += [
        f"set policy route-map {ROUTE_MAP_DN42_ROA} rule 10 action 'permit'",
        f"set policy route-map {ROUTE_MAP_DN42_ROA} rule 10 match rpki 'valid'",
        f"set policy route-map {ROUTE_MAP_DN42_ROA} rule 20 action 'permit'",
        f"set policy route-map {ROUTE_MAP_DN42_ROA} rule 20 match rpki 'notfound'",
        f"set policy route-map {ROUTE_MAP_DN42_ROA} rule 30 action 'deny'",
        f"set policy route-map {ROUTE_MAP_DN42_ROA} rule 30 match rpki 'invalid'",
    ]

    return cmds
