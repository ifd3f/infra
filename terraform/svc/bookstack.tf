resource "mysql_database" "bookstack" {
  name = "bookstack"
}

resource "random_password" "bookstack_password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "random_password" "bookstack_key" {
  length = 32
  special = true
  override_special = "_%@{}~`[]()"
}

resource "mysql_user" "bookstack" {
  user = "bookstack"
  plaintext_password  = random_password.bookstack_password.result
  host = "192.168.1.%"
}

resource "mysql_grant" "bookstack" {
  user = mysql_user.bookstack.user
  host = mysql_user.bookstack.host
  database = mysql_database.bookstack.name
  privileges = ["ALL PRIVILEGES"]
}

resource "kubernetes_namespace" "bookstack" {
  metadata {
    name = "bookstack"
  }
}

resource "kubernetes_secret" "bookstack-db" {
  type = "Opaque"

  metadata {
    name = "bookstack-db"
    namespace = kubernetes_namespace.bookstack.metadata[0].name
  }

  data = {
    "APP_KEY" = random_password.bookstack_key.result
    "DB_USER" = mysql_user.bookstack.user
    "DB_PASS" = random_password.bookstack_password.result
    "DB_HOST" = var.mysql_host
    "DB_PORT" = var.mysql_port
    "DB_DATABASE" = mysql_database.bookstack.name
  }
}