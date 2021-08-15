#!/bin/bash

set -o xtrace  # logging commands as they are run

echo "Installing packages"
dnf install -y \
    cloud-init \
    dnf-plugins-core \
    ansible \
    openssh-server

echo "Configuring sshd"
cp /tmp/sshd_config /etc/ssh/sshd_config

echo "Creating ansible operator user"
useradd -m -c "Ansible Operator" -G wheel ansible

echo "Giving ansible user passwordless sudo"
cp /tmp/ansible-sudo /etc/sudoers.d/ansible

echo "Adding ansible user's public key"
mkdir -p /home/ansible/.ssh
cat /tmp/ansible_ssh.pub >> /home/ansible/.ssh/authorized_keys

chmod 700 /home/ansible/.ssh
chmod 644 /home/ansible/.ssh/authorized_keys
chown -R ansible /home/ansible/.ssh

echo "Enabling SSH"
systemctl enable sshd
systemctl restart sshd
