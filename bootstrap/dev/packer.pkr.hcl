source "qemu" "proxmox_seed" {
  iso_url           = "https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso"
  iso_checksum      = "511cd2efe3d567c0f93dc39cef3c68d57242c144b3634e8e6c560546636a9542"
  memory            = "1024"
  output_directory  = "images"
  shutdown_command  = "echo 'devpassword' | sudo -S shutdown -P now"
  disk_size         = "8000M"
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "http"
  ssh_username      = "debian"
  ssh_password      = "devpassword"
  ssh_timeout       = "20m"
  vm_name           = "proxmox_seed.qcow2"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "2s"
  boot_command      = ["<esc>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/d-i/bullseye/preseed.cfg<enter>"]
}

source "qemu" "freeipa_server" {
  iso_url           = "https://download.fedoraproject.org/pub/fedora/linux/releases/34/Server/x86_64/iso/Fedora-Server-dvd-x86_64-34-1.2.iso"
  iso_checksum      = "83df7ac594cae36721ad1fc4644b97cfed37f5ecac5017466745e9e85e6208f24f36cf0f8e0df190aec7ec77dc34a5534ff9cff115bc10cf3a42b2a5b0303b1b"
  memory            = "1024"
  output_directory  = "images"
  shutdown_command  = "echo 'devpassword' | sudo -S shutdown -P now"
  disk_size         = "8000M"
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "http"
  ssh_username      = "fedora"
  ssh_password      = "devpassword"
  ssh_timeout       = "20m"
  vm_name           = "freeipa_server.qcow2"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "2s"
  boot_command      = [
    "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks-freeipa.cfg<enter><wait>"
  ]
}

build {
  sources = [
    "source.qemu.freeipa_server", 
    "source.qemu.proxmox_seed"
  ]
}
