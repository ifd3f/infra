terraform {
  required_version = ">= 0.13.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0"
    }
    mysql = {
      source  = "terraform-providers/mysql"
      version = ">= 1.5"
    }
  }
}

variable "mysql_endpoint" {
  description = "MySQL server endpoint."
  type        = string
}

variable "mysql_admin_user" {
  description = "MySQL server administrator's username."
  type        = string
}

variable "mysql_admin_password" {
  description = "MySQL server administrator's password."
  type        = string
  sensitive   = true
}

provider "mysql" {
  endpoint = var.mysql_endpoint
  username = var.mysql_admin_user
  password = var.mysql_admin_password
  tls = "skip-verify"
}

resource "mysql_database" "firefly" {
  name = "fireflyiii"
}

resource "random_password" "firefly_password" {
  length = 16
  special = true
  override_special = "_%@"
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
  #privileges = ["SELECT", "UPDATE", "ALTER", "ALTER_ROUTINE", "EXECUTE", "INDEX", "INSERT", "CREATE", "DROP"]
  privileges = ["ALL"]
}
