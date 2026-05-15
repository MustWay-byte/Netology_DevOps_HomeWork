# ========== Переменные для ресурсов ВМ (замена одиночных) ==========
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
  }))
  default = {
    web = {
      cores         = 2
      memory        = 2
      core_fraction = 5
      hdd_size      = 30
      hdd_type      = "network-hdd"
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 30
      hdd_type      = "network-hdd"
    }
  }
}

# ========== Закомментированные (более не используемые) переменные ==========

# variable "vm_web_name" { ... }
# variable "vm_web_cores" { ... }
# variable "vm_web_memory" { ... }
# variable "vm_web_core_fraction" { ... }
# variable "vm_web_boot_disk_size" { ... }
# variable "vm_db_name" { ... }
# variable "vm_db_cores" { ... }
# variable "vm_db_memory" { ... }
# variable "vm_db_core_fraction" { ... }
# variable "vm_db_boot_disk_size" { ... }

# ========== Оставшиеся используемые переменные ==========

variable "vm_web_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_web_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "vm_web_preemptible" {
  type    = bool
  default = true
}

variable "vm_web_image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "vm_db_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_db_zone" {
  type    = string
  default = "ru-central1-b"
}

variable "vm_db_preemptible" {
  type    = bool
  default = true
}
