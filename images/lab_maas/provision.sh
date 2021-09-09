#!/bin/bash

set -o xtrace  # logging commands as they are run

echo "Installing Apt packages"
apt-get update && apt-get install -y \
    snapd \
    cloud-init \
    ansible \
    openssh-server \
    firewalld \
    nftables

echo "Installing Snap packages"
snap install maas maas-test-db

maas init region+rack --database-uri maas-test-db:///
maas createadmin

echo "Configuring sshd"
cat /tmp/sshd_config > /etc/ssh/sshd_config

echo "Enabling passwordless sudo"
cat /tmp/passwordless-sudo > /etc/sudoers.d/passwordless

echo "Enabling SSH, firewalld"
systemctl enable sshd.service
systemctl enable firewalld.service

echo "Allowing SSH traffic"
systemctl start firewalld.service
firewall-cmd --add-service=ssh --permanent

echo "Deleting SSH host keys"
rm /etc/ssh/ssh_host_*_key 
