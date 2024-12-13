#!/usr/bin/env python3
import re
import logging
import os
import subprocess
import tempfile
import typing as t
import argparse
import json
from dataclasses import dataclass
from pprint import pprint

CONFIG_ENV = "VFIOHOTPLUG_CONFIG_PATH"

logger = logging.getLogger(__name__)


@dataclass
class Device:
    type: t.Literal["usb"] | t.Literal["pci"]
    vendor: str
    product: str


@dataclass
class Config:
    connection: str
    dom: str
    groups: t.Dict[str, t.List[Device]]


@dataclass
class PCIPath:
    domain: str
    bus: str
    slot: str
    function: str


def parser():
    parser = argparse.ArgumentParser(
        prog="vfiohotplug",
        description="Helper for hotplugging devices into the VM",
    )

    parser.add_argument(
        "-v",
        "--verbose",
        help="Enable verbose logging",
        action="store_true",
    )

    subparsers = parser.add_subparsers(dest="command")
    attach = subparsers.add_parser("attach", aliases=["a"], help="attach device groups")
    detach = subparsers.add_parser("detach", aliases=["d"], help="detach device groups")
    subparsers.add_parser("list", aliases=["l"], help="list available device groups")

    for p in [attach, detach]:
        p.add_argument("devices", help="Device names to add", nargs="+")

    return parser


def main():
    args = parser().parse_args()
    config = get_config()
    logging.basicConfig(level=logging.DEBUG if args.verbose else logging.INFO)

    match args.command:
        case "list" | "l":
            pprint(config)
        case "attach" | "a":
            manage_devices("attach", args.devices, config)
        case "detach" | "d":
            manage_devices("detach", args.devices, config)
        case cmd:
            parser().print_help()


def manage_devices(action: str, query_groups: t.List[str], config: Config):
    assoced = {assoc_group_name(g, config) for g in query_groups}
    logger.info("%sing device groups: %s", action, assoced)

    for g in assoced:
        for d in config.groups[g]:
            try:
                manage_device(action, d, config)
            except subprocess.CalledProcessError:
                logger.warning(f"{action} failed, continuing to next device")


def assoc_group_name(query: str, config: Config) -> str:
    possible_groups = [full for full in config.groups if full.startswith(query)]

    match possible_groups:
        case []:
            raise KeyError(f"Could not find valid group that starts with {query!r}")
        case [only]:
            return only
        case more:
            raise KeyError(f"Found more than one group for query {query!r}: {more!r}")


def manage_device(action: str, device: Device, config: Config):
    with tempfile.NamedTemporaryFile("w") as f:
        match device.type:
            case "usb":
                xml = f"""<hostdev mode="subsystem" type="{device.type}" managed="yes">
<source>
<vendor id="0x{device.vendor}" />
<product id="0x{device.product}" />
</source>
</hostdev>"""
            case "pci":
                path = find_pci_path(device.vendor, device.product)
                xml = f"""
<hostdev mode="subsystem" type="pci" managed="yes">
  <source>
    <address domain="0x{path.domain}" bus="0x{path.bus}" slot="0x{path.slot}" function="0x{path.function}"/>
  </source>
</hostdev>"""
        logger.debug("Writing XML file %r: %r", f.name, xml)

        f.write(xml)
        f.flush()

        args = [
            "virsh",
            "-c",
            config.connection,
            f"{action}-device",
            config.dom,
            "--persistent",
            "--file",
            f.name,
        ]

        logger.debug("running %r", args)
        proc = subprocess.Popen(
            args,
            env=os.environ,
        )
        proc.wait()
        if proc.returncode != 0:
            raise subprocess.CalledProcessError(proc.returncode, proc.args)


def run_cmd(args: str):
    subprocess.check_output(args)


def get_config() -> Config:
    path = os.getenv(CONFIG_ENV)
    if not path:
        raise EnvironmentError(f"{CONFIG_ENV} environment variable not provided!")

    with open(path) as f:
        raw = json.load(f)
        return Config(
            connection=raw["connection"],
            dom=raw["dom"],
            groups={
                k: [parse_device(d) for d in ds] for k, ds in raw["groups"].items()
            },
        )


def parse_device(d: dict) -> Device:
    dt = d["type"]
    if dt not in ["usb", "pci"]:
        raise ValueError(f"Unexpected device type {dt}")
    try:
        vendor, product = d["id"].split(":")
    except ValueError:
        raise ValueError(f"ID not in <vendor>:<product> form: {d['id']}")
    return Device(dt, vendor, product)


def find_pci_path(vendor: str, product: str) -> PCIPath:
    vpid = f"{vendor}:{product}"
    logger.debug("querying path of device %s", vpid)
    output = (
        subprocess.check_output(["lspci", "-d", vpid, "-D"])
        .decode()
        .strip()
        .splitlines()
    )

    results = [
        PCIPath(*re.match(r"(\d+):(\d+):(\d+).(\d+).*", l).groups()) for l in output
    ]
    logger.info("associated pci:%s to paths: %r", vpid, results)
    return results[0]


if __name__ == "__main__":
    main()
