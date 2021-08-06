# Note: You can use any Debian/Ubuntu based image you want. 
FROM mcr.microsoft.com/vscode/devcontainers/base:0-buster

# Options
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG ENABLE_NONROOT_DOCKER="true"
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${SOURCE_SOCKET}" "${TARGET_SOCKET}" "${USERNAME}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Install kubectl
RUN curl -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Install Helm
RUN curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash -

# Script copies localhost's ~/.kube/config file into the container and swaps out 
# localhost for host.docker.internal on bash/zsh start to keep them in sync.
COPY copy-kube-config.sh shell-customization.zsh /usr/local/share/
RUN chown ${USERNAME}:root /usr/local/share/copy-kube-config.sh \
    && echo "source /usr/local/share/copy-kube-config.sh" | tee -a /root/.bashrc /root/.zshrc /home/${USERNAME}/.bashrc >> /home/${USERNAME}/.zshrc
RUN chown ${USERNAME}:root /usr/local/share/shell-customization.zsh \
    && echo "source /usr/local/share/shell-customization.zsh" | tee -a /root/.zshrc >> /home/${USERNAME}/.zshrc

# Add hashicorp repo (https://learn.hashicorp.com/tutorials/terraform/install-cli)
RUN echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && (curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -) 

# Add ansible repo (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-debian)
RUN (echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee /etc/apt/sources.list.d/ansible.list) \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

# Add GitHub repo 
RUN (curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg) \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list 

# Add Google Cloud repo (https://cloud.google.com/sdk/docs/install#deb)
RUN (echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list) \
    && (curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -)

# Install additional packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        neovim \
        gh \
        ansible \
        google-cloud-sdk \
        default-mysql-client \
        postgresql-client \
        influxdb-client \
        tcpdump \
        host \
        wget \
        netcat \
        whois \
        dnsutils \
        iputils-arping \
        iputils-tracepath \ 
        iputils-clockdiff 
        
# Install helm-diff for helmfile apply
RUN helm plugin install https://github.com/databus23/helm-diff

# Install helmfile
RUN curl -sSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/v0.139.9/helmfile_linux_amd64 \
    && chmod +x /usr/local/bin/helmfile

# Install KubeDB CLI
RUN curl -sSL -o /usr/local/bin/kubedb https://github.com/kubedb/cli/releases/download/0.8.0/kubedb-linux-amd64 \
    && chmod +x /usr/local/bin/kubedb 

# Install k3sup
RUN curl -sSL https://get.k3sup.dev | sh 

# Install kgctl
RUN curl -sSL -o /usr/local/bin/kgctl https://github.com/squat/kilo/releases/download/0.3.0/kgctl-linux-amd64 \
    && chmod +x /usr/local/bin/kgctl 

# Install Oracle Cloud CLI
RUN curl -sSL https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh \
    | bash -s -- --exec-dir /usr/local/bin --script-dir /usr/local/bin --accept-all-defaults

# Install Bitwarden CLI
RUN curl -sSL -o /tmp/bw.zip "https://vault.bitwarden.com/download/?app=cli&platform=linux" \
    && unzip -p /tmp/bw.zip bw > /usr/local/bin/bw \
    && chmod +x /usr/local/bin/bw 

# Install AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install)
RUN curl -sSL -o /tmp/aws.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    && unzip -d /tmp/aws /tmp/aws.zip \
    && /tmp/aws/aws/install

# Install cf-terraforming
RUN (curl -sSL "https://github.com/cloudflare/cf-terraforming/releases/download/v0.3.0/cf-terraforming_0.3.0_linux_amd64.tar.gz" \
    | tar -zx cf-terraforming > /usr/local/bin/cf-terraforming) \
    && chmod +x /usr/local/bin/cf-terraforming 

# Install Terragrunt
RUN curl -sSL -o /usr/local/bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/v0.31.3/terragrunt_linux_amd64" \
    && chmod +x /usr/local/bin/terragrunt

# Install Terraform
RUN curl -sSL -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/1.0.4/terraform_1.0.4_linux_amd64.zip" \
    && unzip -p /tmp/terraform.zip terraform > /usr/local/bin/terraform \
    && chmod +x /usr/local/bin/terraform 

# Install Packer
RUN curl -sSL -o /tmp/packer.zip "https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_linux_amd64.zip" \
    && unzip -p /tmp/packer.zip packer > /usr/local/bin/packer \
    && chmod +x /usr/local/bin/packer 

# Add in some useful scripts for debugging
COPY bin/* /usr/local/bin/
