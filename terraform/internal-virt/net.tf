resource "lxd_network" "brdevelop" {
  name = "brdevelop"
}

resource "lxd_container" "gigarouter" {
  name  = "gigarouter"
  image = "gigarouter/1/cloud"
  # image = "images:fedora/35/cloud"

  limits = {
    cpu    = 4
    memory = "4GB"
  }

  config = {
    "security.privileged" = true
    "security.nesting"    = true
  }

  device {
    name = "wan"
    type = "nic"
    properties = {
      name    = "wan"
      nictype = "bridged"
      parent  = var.exposed_bridge
    }
  }

  device {
    name = "k8slan"
    type = "nic"
    properties = {
      name    = "k8slan"
      nictype = "bridged"
      parent  = var.kubecluster_bridge
    }
  }

  device {
    name = "devlan"
    type = "nic"
    properties = {
      name    = "devlan"
      network = lxd_network.brdevelop.name
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

