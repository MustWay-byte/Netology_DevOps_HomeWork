# ============================================================
# Данные существующего сервисного аккаунта
# ============================================================
data "yandex_iam_service_account" "sa_storage" {
  name = "sa-storage"
}

resource "yandex_iam_service_account_static_access_key" "sa_storage_key" {
  service_account_id = data.yandex_iam_service_account.sa_storage.id
}

# ============================================================
# Бакет Object Storage
# ============================================================
resource "yandex_storage_bucket" "bucket" {
  bucket     = "mustway-2026-task2-1791180069"
  access_key = yandex_iam_service_account_static_access_key.sa_storage_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_storage_key.secret_key

  anonymous_access_flags {
    read        = true
    list        = true
    config_read = false
  }
}

# ============================================================
# Загрузка картинки
# ============================================================
resource "yandex_storage_object" "image" {
  bucket       = yandex_storage_bucket.bucket.bucket
  key          = "images.jpeg"
  source       = "images.jpeg"
  content_type = "image/jpeg"
  acl          = "public-read"

  access_key = yandex_iam_service_account_static_access_key.sa_storage_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_storage_key.secret_key

  depends_on = [yandex_storage_bucket.bucket]
}

output "bucket_name" {
  value = yandex_storage_bucket.bucket.bucket
}

output "image_url" {
  value = "https://${yandex_storage_bucket.bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.image.key}"
}
