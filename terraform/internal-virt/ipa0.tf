resource "lxd_container" "ipa0" {
  name = "ipa0"
  image = "images:centos/8-Stream/cloud"
  type = "virtual-machine"
  limits = {
    cpu = 4
    memory = "6GB"
  }

  config = {
    "cloud-init.user-data" = file("${var.config_dir}/ipa.yml")
    "cloud-init.network-config" = file("${var.config_dir}/ipa.net.yml")
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

