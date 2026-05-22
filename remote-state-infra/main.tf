resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 bucket с версионированием
resource "yandex_storage_bucket" "tfstate" {
  bucket     = "tfstate-bucket-${random_string.bucket_suffix.result}"
  max_size   = 1073741824   # 1 ГБ

  versioning {
    enabled = true
  }

  # Блокировка через use_lockfile не требует отдельных ресурсов, но можно добавить политику
}

# Сервисный аккаунт для доступа к бакету
resource "yandex_iam_service_account" "sa" {
  name        = "tfstate-sa"
  description = "Service account for Terraform remote state"
}

# Выдаём роль storage.editor на каталог
resource "yandex_resourcemanager_folder_iam_member" "storage_editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Статический ключ доступа для сервисного аккаунта
resource "yandex_iam_service_account_static_access_key" "sa_key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Key for accessing tfstate bucket"
}
