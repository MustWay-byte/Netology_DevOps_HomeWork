variable "cluster_id" {
  description = "ID of the target MySQL cluster"
  type        = string
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
}

variable "user_name" {
  description = "Name of the database user"
  type        = string
}

variable "user_password" {
  description = "Password for the database user"
  type        = string
  sensitive   = true
}
