#!/bin/bash

set -o xtrace  # logging commands as they are run

echo "Installing packages"
dnf install -y \
    cloud-init \
    dnf-plugins-core \
    ansible \
    openssh-server \
    freeipa-client \
    firewalld \
    nftables

echo "Configuring sshd"
cat /tmp/sshd_config > /etc/ssh/sshd_config

echo "Enabling passwordless sudo"
cat /tmp/passwordless-sudo > /etc/sudoers.d/passwordless

echo "Enabling SSH, firewalld"
systemctl enable sshd.service
systemctl enable firewalld.service

echo "Disabling chronyd"
systemctl disable chronyd.service 

echo "Allowing SSH traffic"
systemctl start firewalld.service
firewall-cmd --add-service=ssh --permanent