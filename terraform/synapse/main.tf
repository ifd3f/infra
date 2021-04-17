provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "random_password" "synapse_db_password" {
  length = 32
  number = true
  special = true
  override_special = "_%@{}~`[]()"
}

resource "kubernetes_secret" "synapse" {
  type = "Opaque"

  metadata {
    name = "synapse-db-creds"
    namespace = "matrix"
  }

  data = {
    "POSTGRES_USER" = "synapse"
    "POSTGRES_PASSWORD" = random_password.synapse_db_password.result
  }
}