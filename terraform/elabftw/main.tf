provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "random_password" "elabftw_app_key" {
  length = 32
  number = true
  special = true
  override_special = "_%@{}~`[]()"
}

resource "kubernetes_secret" "elabftw" {
  type = "Opaque"

  metadata {
    name = "elabftw-secret-key"
    namespace = "elabftw"
  }

  data = {
    "SECRET_KEY" = random_password.elabftw_app_key.result
  }
}