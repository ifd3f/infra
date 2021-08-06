# Fedora
resource "libvirt_volume" "fedora" {
  name   = "fedora-server.iso"
  source = "images/fedora.iso"
}

# Debian
resource "libvirt_volume" "debian" {
  name   = "debian.iso"
  source = "images/debian.iso"
}