#!/bin/bash

set -o xtrace  # logging commands as they are run

echo "Installing packages"
dnf install -y \
    freeipa-server \
    freeipa-server-dns 