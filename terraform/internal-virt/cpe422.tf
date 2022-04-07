resource "lxd_container" "cpe422" {
  name = "cpe422"
  image = "images:fedora/35/cloud"
  type = "virtual-machine"

  lifecycle {
    # i don't wanna destroy my code
    # prevent_destroy = true
  }

  limits = {
    cpu = 8
    memory = "16GB"
  }

  config = {
    "cloud-init.user-data" = file("${var.config_dir}/cpe422.yml")
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent = var.exposed_bridge
    }
  }

  device {
    name = "rootvol"
    type = "disk"
    properties = {
      path = "/"
      size = "50GB"
      pool = lxd_storage_pool.dpool.id
    }
  }
}

