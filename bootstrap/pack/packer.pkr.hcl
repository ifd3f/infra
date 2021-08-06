source "qemu" "example" {
  iso_url           = "https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso"
  iso_checksum      = "511cd2efe3d567c0f93dc39cef3c68d57242c144b3634e8e6c560546636a9542"
  memory            = "1024"
  output_directory  = "out"
  shutdown_command  = "echo 'devpassword' | sudo -S shutdown -P now"
  disk_size         = "30000M"
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "http"
  ssh_username      = "debian"
  ssh_password      = "devpassword"
  ssh_timeout       = "20m"
  vm_name           = "debian-basic"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "2s"
  boot_command      = ["<esc>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/d-i/bullseye/preseed.cfg<enter>"]
}

build {
  sources = ["source.qemu.example"]
}
