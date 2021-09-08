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

locals {
  nix_ovmf_location = "/run/libvirt/nix-ovmf/OVMF_CODE.fd"
}

resource "libvirt_pool" "bongus_guests" {
  name = "guests"
  type = "dir"
  path = "/srv/guests"
}

resource "libvirt_network" "lan_bridge" {
  name = "br0"
  mode = "bridge"
  bridge = "br0"
}

// Talos installation disk.
resource "libvirt_volume" "talos_os" {
  name   = "talos-amd64-v0.12.1.iso"
  pool   = libvirt_pool.bongus_guests.name
  source = "https://github.com/talos-systems/talos/releases/download/v0.12.1/talos-amd64.iso"
}

resource "libvirt_volume" "boot_disk" {
  name   = "master.qcow2"
  pool   = libvirt_pool.bongus_guests.name
  size   = 20 * 1024 * 1024 * 1024 // 20GiB
}

resource "libvirt_domain" "nixos_test" {
  name        = "tiber-septim"
  description = "Talos OS"
  memory      = 4000
  vcpu        = 2
  autostart   = false
  firmware    = local.nix_ovmf_location

  network_interface {
    network_name = libvirt_network.lan_bridge.name
  }

  disk {
    volume_id = libvirt_volume.talos_os.id
  }

  disk {
    volume_id = libvirt_volume.boot_disk.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  xml {
    xslt = file("modify.xslt")
  }
}
