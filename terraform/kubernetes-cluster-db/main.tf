terraform {
  required_version = ">= 0.13.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    mysql = {
      source  = "terraform-providers/mysql"
      version = ">= 1.5"
    }
  }
}

provider "mysql" {
  endpoint = "${var.mysql_host}:${var.mysql_port}"
  username = var.mysql_admin_user
  password = var.mysql_admin_password
}

resource "mysql_database" "kube" {
  name = "kube"
}

resource "random_password" "kube_password" {
  length = 32
  special = true
  number = true
  override_special = "~!@#$%^&*"
}

resource "random_password" "kube_key" {
  length = 32
  number = true
  special = true
  override_special = "_%@{}~`[]()"
}

resource "mysql_user" "kube" {
  user = "kube"
  plaintext_password  = random_password.kube_password.result
  host = "%"
}

resource "local_file" "kube_password" {
  content = random_password.kube_password.result
  filename = "${path.module}/credentials/mysql_${mysql_user.kube.user}.txt"
}

resource "mysql_grant" "kube" {
  user = mysql_user.kube.user
  host = mysql_user.kube.host
  database = mysql_database.kube.name
  privileges = ["ALL"]
}