provider "yandex" {
  cloud_id                 = "b1gr8dpt0el2sc1i0p33"
  folder_id                = "b1g5m6nu8f7nl3dmsjot"
  service_account_key_file = file("~/.authorized_key.json")
  zone                     = "ru-central1-a"
}

resource "yandex_storage_bucket" "my_bucket" {
  bucket     = "simple-bucket-mustway-abc123"   # уникальное имя
  max_size   = 1073741824   # 1 ГБ

  versioning {
    enabled = true
  }
}

output "bucket_name" {
  value = yandex_storage_bucket.my_bucket.bucket
}
