FROM ubuntu:hirsute

# Install tools for package management
RUN apt-get update && apt-get install -y gnupg apt-transport-https ca-certificates curl

# Add hashicorp repo (https://learn.hashicorp.com/tutorials/terraform/install-cli)
RUN echo "deb [arch=amd64] https://apt.releases.hashicorp.com hirsute main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && (curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -) 

# Add Kubernetes repo (https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    && (echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" \
        | tee /etc/apt/sources.list.d/kubernetes.list)

RUN apt-get update && apt-get install -y \
    gettext \
    terraform \
    ansible \
    kubectl 

# Clone the git repo
WORKDIR /infra
RUN apt-get install -y git
RUN git clone https://github.com/astralbijection/infrastructure.git --no-checkout .
RUN git sparse-checkout init --cone \
    && git sparse-checkout set ansible terraform kubernetes \
    && git checkout

COPY ./start.sh /usr/local/bin/start.sh
WORKDIR /infra/ansible
CMD start.sh