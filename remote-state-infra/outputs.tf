output "bucket_name" {
  value = yandex_storage_bucket.tfstate.bucket
}

output "access_key_id" {
  value     = yandex_iam_service_account_static_access_key.sa_key.access_key
  sensitive = true
}

output "secret_access_key" {
  value     = yandex_iam_service_account_static_access_key.sa_key.secret_key
  sensitive = true
}

output "backend_config" {
  value = <<-EOT
    backend "s3" {
      bucket  = "${yandex_storage_bucket.tfstate.bucket}"
      key     = "terraform.tfstate"
      region  = "ru-central1"

      endpoints = {
        s3 = "https://storage.yandexcloud.net"
      }

      skip_region_validation      = true
      skip_credentials_validation = true
      skip_requesting_account_id  = true
      skip_s3_checksum            = true
    }
  EOT
}
