variable "test_list" {
  type    = list(string)
  default = ["John", "admin", "production", "ubuntu-20-04"]
}

variable "test_map" {
  type = map(string)
  default = {
    admin = "John"
    role  = "admin"
  }
}

variable "servers" {
  type = map(object({
    vcpu  = number
    ram   = number
    disks = number
  }))
  default = {
    prod = {
      vcpu  = 4
      ram   = 16
      disks = 5
    }
  }
}

variable "test" {
  type = list(map(list(string)))
  default = [
    {
      "dev1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
        "10.0.1.7",
      ]
    },
    {
      "dev2" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
        "10.0.2.29",
      ]
    },
    {
      "prod1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
        "10.0.1.30",
      ]
    },
  ]
}
