#!/bin/bash

set -o xtrace  # logging commands as they are run

echo "Loading yum repositories"
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

echo "Installing packages"
dnf install -y \
    vault 

echo "Creating vault data directory"
mkdir -p /vault/data

cp /tmp/config.hcl /vault/config.hcl
cp /tmp/vault.service /etc/systemd/system/hashicorp-vault.service

systemctl enable hashicorp-vault.service