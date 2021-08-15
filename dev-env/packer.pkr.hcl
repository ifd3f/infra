source "qemu" "fedora_server" {
  iso_url           = "https://download.fedoraproject.org/pub/fedora/linux/releases/34/Server/x86_64/iso/Fedora-Server-dvd-x86_64-34-1.2.iso"
  iso_checksum      = "83df7ac594cae36721ad1fc4644b97cfed37f5ecac5017466745e9e85e6208f24f36cf0f8e0df190aec7ec77dc34a5534ff9cff115bc10cf3a42b2a5b0303b1b"
  memory            = "1024"
  output_directory  = "${path.root}/images"
  shutdown_command  = "echo 'devpassword' | sudo -S shutdown -P now"
  disk_size         = "10G"
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "http"
  ssh_username      = "fedora"
  ssh_password      = "devpassword"
  ssh_timeout       = "20m"
  vm_name           = "fedora_server.qcow2"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "2s"
  boot_command      = [
    "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kickstart.cfg<enter><wait>"
  ]
}

build {
  sources = [
    "source.qemu.fedora_server", 
  ]
}
