variable "cloud_id" {
  type        = string
  description = "Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "default_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "vpc_name" {
  type    = string
  default = "develop"
}

# переменная vms_ssh_public_root_key больше не используется
# variable "vms_ssh_public_root_key" {
#   type        = string
#   default     = ""
#   description = "Public SSH key for VM"
# }

variable "vms_metadata" {
  type        = map(string)
  description = "Common metadata for all VMs (serial-port-enable, ssh-keys)"
}
