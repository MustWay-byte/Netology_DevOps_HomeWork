terraform {
  required_version = "~>1.15.0"
  
  backend "s3" {
    bucket  = "simple-bucket-mustway-abc123"
    key     = "terraform.tfstate"
    region  = "ru-central1"
    
    use_lockfile = true
    
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
  
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.203"
    }
  }
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "yc_sa_key_path" {
  description = "Path to service account key file"
  type        = string
  sensitive   = true
}

provider "yandex" {
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  service_account_key_file = file(var.yc_sa_key_path)
  zone                     = "ru-central1-a"
}
