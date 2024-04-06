from typing import List, NamedTuple, Optional, Tuple


class WireguardPeer(NamedTuple):
    name: str
    public_key: str
    endpoint: Optional[Tuple[str, int]]

    def render(self, ifname: str) -> List[str]:
        cmds = [
            f"set interfaces wireguard {ifname} peer {self.name} public-key {self.public_key}",
            f"set interfaces wireguard {ifname} peer {self.name} allowed-ips '::/0'",
            f"set interfaces wireguard {ifname} peer {self.name} allowed-ips '0.0.0.0/0'",
        ]

        match self.endpoint:
            case (addr, port):
                cmds += [
                    f"set interfaces wireguard {ifname} peer {self.name} port {port}",
                    f"set interfaces wireguard {ifname} peer {self.name} address {addr}",
                ]

        return cmds


class WireguardTunnel(NamedTuple):
    ifname: str
    our_address_cidr: str
    our_private_key: str
    description: str
    peers: List[WireguardPeer]
    our_endpoint_port: Optional[int] = None

    def render(self) -> List[str]:
        cmds = [
            f"delete interfaces wireguard {self.ifname}",
            f"set interfaces wireguard {self.ifname} address {self.our_address_cidr}",
            f"set interfaces wireguard {self.ifname} description {self.description}",
            f"set interfaces wireguard {self.ifname} private-key {self.our_private_key}",
        ]
        for p in self.peers:
            cmds += p.render(self.ifname)

        if self.our_endpoint_port is not None:
            cmds.append(
                f"set interfaces wireguard {self.ifname} port {self.our_endpoint_port}"
            )

        return cmds


class LinkLocalBgpPeer(NamedTuple):
    ifname: str
    description: str
    peer_address: str
    peer_asn: int
    peer_group: str

    def render(self) -> List[str]:
        return [
            f"delete protocols bgp neighbor {self.peer_address}",
            f"set protocols bgp neighbor {self.peer_address} description {self.description}",
            f"set protocols bgp neighbor {self.peer_address} interface source-interface {self.ifname}",
            f"set protocols bgp neighbor {self.peer_address} interface v6only",
            f"set protocols bgp neighbor {self.peer_address} peer-group {self.peer_group}",
            f"set protocols bgp neighbor {self.peer_address} remote-as {self.peer_asn}",
            f"set protocols bgp neighbor {self.peer_address} update-source {self.ifname}",
        ]
