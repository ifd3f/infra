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
  mode      = "nat"
  bridge    = "virbr-outer"
  addresses = ["192.168.5.0/24"]

  dns {
    enabled = true
    forwarders { 
      address = "8.8.8.8" 
    }
  }
}

# Inner network for me and my machines only
resource "libvirt_network" "inner" {
  name      = "bootstrap-dev-inner"
  mode      = "none"
  bridge    = "virbr-inner"
  addresses = []
}

resource "libvirt_volume" "nixos_installer" {
  count = 4
  name = "customized-nixos-${count.index}.iso"
  source = var.installer_path
}