variable "cluster_name" {
  description = "Name of the MySQL cluster"
  type        = string
}

variable "network_id" {
  description = "ID of the VPC network"
  type        = string
}

variable "ha" {
  description = "High availability: true = 2 hosts, false = 1 host"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of subnet IDs (one for single, two for HA)"
  type        = list(string)
}

variable "zone_ids" {
  description = "List of availability zones (must match subnet_ids order)"
  type        = list(string)
}
