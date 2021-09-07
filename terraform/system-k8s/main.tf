terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  // TODO make this DNS
  uri = "qemu+ssh://astrid@192.168.1.112/system"
}

resource "libvirt_pool" "bongus_guests" {
  name = "guests"
  type = "dir"
  path = "/srv/guests"
}

resource "libvirt_volume" "talos_os" {
  name   = "talos-amd64.iso"
  pool   = libvirt_pool.bongus_guests.name
  source = "https://github.com/talos-systems/talos/releases/download/v0.12.1/talos-amd64.iso"
}

resource "libvirt_volume" "boot_disk" {
  name   = "master.qcow2"
  pool   = libvirt_pool.bongus_guests.name
  size   = 20 * 1024 * 1024 * 1024 // 20GiB
}

# resource "libvirt_domain" "master" {
#   name = "test"
# }
