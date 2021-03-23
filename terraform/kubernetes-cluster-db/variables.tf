
variable "mysql_host" {
  description = "MySQL server host."
  type        = string
}

variable "mysql_port" {
  description = "MySQL server port."
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