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
