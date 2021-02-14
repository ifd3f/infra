resource "mysql_database" "firefly" {
  name = "fireflyiii"
}

resource "random_password" "firefly_password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "random_password" "firefly_key" {
  length = 32
  special = true
  override_special = "_%@{}~`[]()"
}

resource "mysql_user" "firefly" {
  user = "fireflyop"
  plaintext_password  = random_password.firefly_password.result
  host = "192.168.1.%"
}

resource "mysql_grant" "firefly" {
  user = mysql_user.firefly.user
  host = mysql_user.firefly.host
  database = mysql_database.firefly.name
  privileges = ["ALL PRIVILEGES"]
}

resource "kubernetes_secret" "firefly" {
  type = "Opaque"

  metadata {
    name = "firefly-db"
    namespace = "firefly-iii"
  }

  data = {
    "APP_KEY" = random_password.firefly_key.result
    "DB_USERNAME" = mysql_user.firefly.user
    "DB_PASSWORD" = random_password.firefly_password.result
    "DB_HOST" = var.mysql_host
    "DB_PORT" = 3306
    "DB_DATABASE" = mysql_database.firefly.name
    "DB_CONNECTION" = "mysql"
    "MYSQL_USE_SSL" = "true"
    "MYSQL_SSL_VERIFY_SERVER_CERT" = "false"
    "MYSQL_SSL_CAPATH" = "/etc/ssl/certs/"
  }
}