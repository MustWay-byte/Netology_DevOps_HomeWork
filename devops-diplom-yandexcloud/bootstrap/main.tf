# Сервисный аккаунт для работы с Object Storage
resource "yandex_iam_service_account" "bucket_sa" {
  name        = "bucket-sa"
  description = "Service account for S3 backend (Terraform state)"
}

resource "yandex_resourcemanager_folder_iam_member" "bucket_sa_role" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.bucket_sa.id}"
}

# Статический ключ доступа для bucket-sa
resource "yandex_iam_service_account_static_access_key" "bucket_sa_key" {
  service_account_id = yandex_iam_service_account.bucket_sa.id
  description        = "Static access key for bucket-sa"
  depends_on         = [yandex_resourcemanager_folder_iam_member.bucket_sa_role]
}

# S3-бакет для хранения стейта Terraform
resource "yandex_storage_bucket" "tfstate" {
  bucket     = "mustway-tfstate-bucket-2026" # глобально уникальное имя
  access_key = yandex_iam_service_account_static_access_key.bucket_sa_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket_sa_key.secret_key

  max_size = 1073741824 # 1 GB
}
