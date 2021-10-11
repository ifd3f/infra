# Wireguard Keys

This folder contains Wireguard VPN public keys. To generate a new key, there is a [convenience script](../scripts/mkwgkey.sh). Call it in the repo root like so:

```sh
$ ls wireguard/
deprecated  README.md
$ scripts/mkwgkey.sh wireguard/banana
$ ls wireguard/
banana.key  banana.pub  deprecated  README.md
```

Your private key will be the newly-generated file ending in `.key`.
