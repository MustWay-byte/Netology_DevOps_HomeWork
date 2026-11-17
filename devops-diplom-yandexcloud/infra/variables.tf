variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "ssh_public_key" {
  description = "SSH public key for compute instances"
  type        = string
  sensitive   = true
}
