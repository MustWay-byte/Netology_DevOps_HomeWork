variable "env_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnets" {
  description = "List of subnets with zone and CIDR"
  type = list(object({
    zone = string
    cidr = string
  }))
  default = []
}
