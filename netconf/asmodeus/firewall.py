from typing import List, NamedTuple, Optional

from .constants import dn42_allowed_transit, ifd3f_dn42
from .utils import NetGroup, afs


DN42_ALLOWED_TRANSIT = "dn42-allowed-transit"
IFD3F_DN42 = "ifd3f-dn42"


class Rule(NamedTuple):
    description: str
    cmds: List[str]
    src: Optional[NetGroup] = None
    dst: Optional[NetGroup] = None

    def render(self, firewall_name: str, rule_num: int) -> List[str]:
        cmds = []
        for af in afs:
            srcname = af.suffix(self.src.base_name) if self.src else None
            dstname = af.suffix(self.dst.base_name) if self.dst else None
            cmds.append(
                f"set firewall name {firewall_name} rule {rule_num} description {self.description}"
            )
            if srcname:
                cmds.append(
                    f"set firewall {af.firewall_name} name {firewall_name} rule {rule_num} source group network-group {srcname}"
                )
            if dstname:
                cmds.append(
                    f"set firewall {af.firewall_name} name {firewall_name} rule {rule_num} destination group network-group {dstname}"
                )
            for cmd in self.cmds:
                cmds.append(
                    f"set firewall {af.firewall_name} name {firewall_name} rule {rule_num} {cmd}"
                )
        return cmds


def make_firewall() -> List[str]:
    cmds = []
    cmds += [
        "delete firewall",
        "set firewall global-options state-policy established action 'accept'",
        "set firewall global-options state-policy related action 'accept'",
        "set firewall global-options state-policy invalid action 'accept'",
    ]

    cmds += dn42_allowed_transit.make_firewall_groups()
    cmds += ifd3f_dn42.make_firewall_groups()
    cmds += inbound_connections()

    return cmds


def inbound_connections() -> List[str]:
    return make_named_firewall(
        name="dn42-tunnels-in",
        description="'DN42 peering tunnels, inbound traffic'",
        rules=[
            Rule(
                description="Block Traffic to Operator Assigned IP Space",
                dst=ifd3f_dn42,
                cmds=["action drop"],
            ),
            Rule(
                description="Allow Peer Transit",
                src=dn42_allowed_transit,
                dst=dn42_allowed_transit,
                cmds=["action accept"],
            ),
        ],
    )


def make_named_firewall(
    name: str, description: str, rules: List[Rule], default_action: str = "drop"
) -> List[str]:
    cmds = []

    for af in afs:
        cmds.extend(
            [
                f"set firewall {af.firewall_name} name {af.suffix(name)} default-action {default_action}",
                f"set firewall {af.firewall_name} name {af.suffix(name)} description {description}",
            ]
        )

    for i, r in enumerate(rules):
        cmds.extend(r.render(name, i + 1))
    return cmds
