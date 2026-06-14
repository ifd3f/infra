#!/usr/bin/env python3

import argparse
import logging
from pathlib import Path
import os
import subprocess
import sys


logger = logging.getLogger(__name__)

ca_dir = Path(__file__).parent


def main():
    logging.basicConfig(level=logging.DEBUG)

    parser = argparse.ArgumentParser(
        description="PKI helper",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    p_genpkey = sub.add_parser(
        "genpkey",
        help="Generate an elliptic curve private key to stdout.",
    )
    p_genpkey.set_defaults(func=lambda args: genpkey())

    p_setuprootca = sub.add_parser(
        "setuprootca",
        help="Initialise root CA directory structure and self-sign a ~20-year certificate.",
    )
    p_setuprootca.add_argument("privkey", help="Path to the CA private key.")
    p_setuprootca.set_defaults(func=lambda args: setuprootca(ca_privkey=args.privkey))

    p_sign = sub.add_parser(
        "sign",
        help="Sign a CSR with the root CA.",
    )
    p_sign.add_argument("key", help="Path to the CA private key.")
    p_sign.add_argument("csr", help="Path to the CSR to sign.")
    p_sign.set_defaults(func=sign)

    p_ykreq = sub.add_parser(
        "ykreq",
        help="Generate a key on a YubiKey PIV slot and produce a CSR.",
    )
    p_ykreq.add_argument("slot", help="PIV slot ID (e.g. 9a).")
    p_ykreq.set_defaults(func=lambda args: ykreq(args.slot))

    args = parser.parse_args()
    args.func(args)


def run(*args, **kwargs):
    """Run a command and ensure it doesn't crash."""
    logger.debug("running %s", args)
    return subprocess.run(args, check=True, **kwargs)


def genpkey():
    run(
        "openssl",
        "genpkey",
        "-text",
        "-algorithm",
        "EC",
        "-pkeyopt",
        "ec_paramgen_curve:P-256",
        "-pkeyopt",
        "ec_param_enc:named_curve",
    )


def setuprootca(ca_privkey: Path):
    os.makedirs("certs", exist_ok=True)
    os.makedirs("newcerts", exist_ok=True)
    os.makedirs("crl", exist_ok=True)

    with open("index.txt", "a") as f:
        pass  # touch

    with open("serial", "w") as f:
        f.write("1000")
    with open("crlnumber", "w") as f:
        f.write("1000")

    proc = run(
        "openssl",
        "req",
        "-x509",
        "-config",
        "./openssl.conf",
        "-section",
        "rootreq",
        "-key",
        ca_privkey,
        "-days",
        "7000",
        "-text",
        capture_output=True,
    )

    sys.stdout.buffer.write(proc.stdout)
    sys.stderr.buffer.write(proc.stderr)

    os.makedirs("certs", exist_ok=True)
    with open("./certs/ca.crt", "wb") as f:
        f.write(proc.stdout)
    logger.info(f"Certificate written to ./certs/ca.crt")


def sign(csr: Path, ca_privkey: Path):
    run(
        "openssl",
        "ca",
        "-config",
        "openssl.conf",
        "-name",
        "CA_root",
        "-in",
        csr,
        "-keyfile",
        ca_privkey,
    )


def ykreq(slot: str):
    info = subprocess.run(["ykman", "info"], check=True, capture_output=True, text=True)
    serial = None
    for line in info.stdout.splitlines():
        if "Serial number:" in line:
            serial = line.split()[-1].strip()
            break
    if serial is None:
        print("Error: could not determine YubiKey serial number.", file=sys.stderr)
        sys.exit(1)

    pubfile = f"./yk{serial}.pub"
    csrfile = f"./yk{serial}.csr"
    subject = (
        f"CN=I.YK.{serial} iykyk,"
        "C=US,"
        "ST=California,"
        "L=San Francisco,"
        "O=astrid dot tech,"
        "OU=DevSecAICatGoonGitChatOps"
    )

    run("ykman", "piv", "keys", "generate", "-a", "RSA2048", slot, pubfile)
    run(
        "ykman",
        "piv",
        "certificates",
        "request",
        "--subject",
        subject,
        slot,
        pubfile,
        csrfile,
    )


if __name__ == "__main__":
    main()
