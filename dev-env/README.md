# Libvirt Development Environment

Because bootstrapping the cluster is a very complex ordeal, a local, virtualized environment may be helpful for testing my code. That's what this folder is for.

Depending you how your computer is set up, Packer and Terraform may need to be run as root.

## 1. Use Packer to build images

The images created by packer should emulate what's on my servers, as closely as possible. They are initialized using preseed files.

To build development images, run
```
packer build .
```

## 2. Use Terraform to deploy VMs

The terraform script provisions and starts up all 3 server analogues in Libvirt. To create it, run

```
terraform apply
```

and to destroy it, run

```
terraform destroy
```

To nuke your environment and start from scratch, run
```
terraform destroy -auto-approve && terraform apply -auto-approve
```