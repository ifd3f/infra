resource "lxd_storage_pool" "dpool" {
  name   = "dpool"
  driver = "zfs"
  config = {
    source          = "dpool/lxd"
    "zfs.pool_name" = "dpool/lxd"
  }
}

