terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.203"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

variable "yc_cloud_id" {
  default = "b1gr8dpt0el2sc1i0p33"
}
variable "yc_folder_id" {
  default = "b1g5m6nu8f7nl3dmsjot"
}

provider "yandex" {
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  service_account_key_file = "/home/mustway/.authorized_key.json"
  zone                     = "ru-central1-a"
}
