terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Outer network that everyone else will use
resource "libvirt_network" "outer" {
  name      = "bootstrap-dev-outer"
  domain    = "tf.local"
  mode      = "nat"
  addresses = ["10.0.1.0/24"]
}

# Inner network for me and my machines only
resource "libvirt_network" "inner" {
  name      = "bootstrap-dev-inner"
  domain    = "tf.local"
  mode      = "none"
  addresses = []
}
