resource "yandex_container_registry" "test_app_registry" {
  name      = "test-app-registry"
  folder_id = var.folder_id
}

output "registry_id" {
  description = "ID реестра контейнеров"
  value       = yandex_container_registry.test_app_registry.id
}

lifecycle {
  prevent_destroy = true
}
