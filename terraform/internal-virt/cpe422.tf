resource "lxd_profile" "cpe422" {
  name = "cpe422"

  config = {
    "cloud-init.user-data" = file("${var.config_dir}/cpe422.yml")
  }
}

resource "lxd_container" "cpe422" {
  name  = "cpe422"
  image = "images:fedora/35/cloud"
  type  = "virtual-machine"

  profiles = [lxd_profile.cpe422.name]

  lifecycle {
    # i don't wanna destroy my code
    # prevent_destroy = true
  }

  limits = {
    cpu    = 8
    memory = "16GB"
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent  = var.exposed_bridge
    }
  }

  device {
    name = "rootvol"
    type = "disk"
    properties = {
      path = "/"
      size = "85GB"
      pool = lxd_storage_pool.dpool.id
    }
  }
}

