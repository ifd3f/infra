provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "random_password" "firefly_app_key" {
  length = 32
  number = true
  special = true
  override_special = "_%@{}~`[]()"
}

resource "kubernetes_secret" "firefly" {
  type = "Opaque"

  metadata {
    name = "firefly-app-key"
    namespace = "firefly-iii"
  }

  data = {
    "APP_KEY" = random_password.firefly_app_key.result
  }
}