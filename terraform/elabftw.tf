resource "mysql_database" "elabftw" {
  name = "elabftw"
}

resource "random_password" "elabftw_password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "random_password" "elabftw_key" {
  length = 32
  special = true
  override_special = "_%@{}~`[]()"
}

resource "mysql_user" "elabftw" {
  user = "elabftw"
  plaintext_password  = random_password.elabftw_password.result
  host = "192.168.1.%"
}

resource "mysql_grant" "elabftw" {
  user = mysql_user.elabftw.user
  host = mysql_user.elabftw.host
  database = mysql_database.elabftw.name
  privileges = ["ALL PRIVILEGES"]
}

resource "kubernetes_secret" "elabftw-db" {
  type = "Opaque"

  metadata {
    name = "elabftw-db"
    namespace = "elabftw"
  }

  data = {
    "SECRET_KEY" = random_password.elabftw_key.result
    "DB_USER" = mysql_user.elabftw.user
    "DB_PASSWORD" = random_password.elabftw_password.result
    "DB_HOST" = var.mysql_host
    "DB_PORT" = var.mysql_port
    "DB_DATABASE" = mysql_database.elabftw.name
    "DB_CONNECTION" = "mysql"
    "MYSQL_USE_SSL" = "true"
    "MYSQL_SSL_VERIFY_SERVER_CERT" = "false"
  }
}