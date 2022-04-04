resource "lxd_container" "ipa0" {
  name = "ipa0"
  image = "images:centos/9-Stream/cloud"
  type = "virtual-machine"
  config = {
    "limits.cpu" = 4
    "limits.memory" = "6GB"
    "cloud-init.user-data" = file("${var.config_dir}/ipa.yml")
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
      pool = lxd_storage_pool.dpool.id
    }
  }
}

