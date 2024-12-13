#!/usr/bin/env python3

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
    type: t.Literal["usb"] | t.Literal["pcie"]
    vendor: str
    product: str


@dataclass
class Config:
    connection: str
    dom: str
    groups: t.Dict[str, t.List[Device]]


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
        xml = f"""<hostdev mode="subsystem" type="{device.type}" managed="yes">
<source>
<vendor id="{device.vendor}" />
<product id="{device.product}" />
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
    if dt not in ["usb", "pcie"]:
        raise ValueError(f"Unexpected device type {dt}")
    try:
        vendor, product = d["id"].split(":")
    except ValueError:
        raise ValueError(f"ID not in <vendor>:<product> form: {d['id']}")
    return Device(dt, "0x" + vendor, "0x" + product)


if __name__ == "__main__":
    main()
