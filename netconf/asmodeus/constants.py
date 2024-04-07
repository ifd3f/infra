from .utils import NetGroup


dn42_as = 4242421846

dn42_allowed_transit = NetGroup(
    base_name="dn42-allowed-transit",
    v4=[
        "10.0.0.0/8",
        "172.20.0.0/14",
        "172.31.0.0/16",
    ],
    v6=["fd00::/8"],
)
ifd3f_dn42 = NetGroup(
    base_name="ifd3f-dn42",
    v4=["172.23.7.176/28"],
    v6=["fd00:ca7:b015::/48"],
)

