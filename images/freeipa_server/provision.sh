#!/bin/bash

set -o xtrace  # logging commands as they are run

echo "Installing packages"
dnf install -y \
    freeipa-server \
    freeipa-server-dns 

echo "Moving auto-install script into PATH"
cp /tmp/auto-install-ipa.sh /usr/local/bin/auto-install-ipa.sh
chmod +x /usr/local/bin/auto-install-ipa.sh
