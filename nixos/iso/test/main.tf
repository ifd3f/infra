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

resource "libvirt_network" "net" {
  name      = "nixos-iso-test"
  mode      = "nat"
  bridge    = "nixos-iso-test"
  addresses = [
    "10.32.12.1/24"
  ]
}
