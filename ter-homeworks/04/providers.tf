terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex", version = "0.203.0" }
    random = { source = "hashicorp/random", version = "3.5.0" }
  }
  required_version = ">= 1.8.4"
}
provider "yandex" {
  cloud_id                 = "b1gr8dpt0el2sc1i0p33"
  folder_id                = "b1g5m6nu8f7nl3dmsjot"
  service_account_key_file = file("~/.authorized_key.json")
  zone                     = "ru-central1-a"
}
