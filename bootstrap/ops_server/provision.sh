#!/bin/bash

set -o xtrace  # logging commands as they are run

echo "Loading yum repositories"
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "Installing packages"
dnf install -y \
    git \
    gettext \
    terraform \
    ansible \
    kubectl \
    cloud-init \
    openssh-server

echo "Enabling SSH"
systemctl enable sshd
systemctl start sshd

echo "Cloning the git repo"
mkdir /infra
git clone https://github.com/astralbijection/infrastructure.git /infra