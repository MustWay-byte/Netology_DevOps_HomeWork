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

provider "yandex" {
  cloud_id                 = "b1gr8dpt0el2sc1i0p33"
  folder_id                = "b1g5m6nu8f7nl3dmsjot"
  service_account_key_file = file("~/.authorized_key.json")
  zone                     = "ru-central1-a"
}
