resource "lxd_profile" "maastricht" {
  name = "maastricht"

  config = {
    "cloud-init.user-data" = file("${var.config_dir}/maastricht.yml")
  }
}

resource "lxd_container" "maastricht" {
  name = "maastricht"
  image = "images:ubuntu/jammy/cloud"

  profiles = [ lxd_profile.maastricht.name ]

  limits = {
    cpu = 2
    memory = "2GB"
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "ipvlan"
      parent = var.kubecluster_bridge
      mode = "l2"
      "ipv4.address" = "192.168.23.2/24"
      "ipv4.gateway" = "192.168.23.1"
    }
  }

  device {
    name = "rootvol"
    type = "disk"
    properties = {
      path = "/"
      size = "8GB"
      pool = lxd_storage_pool.dpool.id
    }
  }
}

