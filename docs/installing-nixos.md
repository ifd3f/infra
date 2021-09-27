# Installing NixOS

## Wifi

https://nixos.org/manual/nixos/stable/#sec-installation-booting-networking

```sh
wpa_supplicant -B -i interface -c <(wpa_passphrase 'SSID' 'key') 
```