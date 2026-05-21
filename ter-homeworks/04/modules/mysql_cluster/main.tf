resource "yandex_mdb_mysql_cluster" "this" {
  name        = var.cluster_name
  environment = "PRESTABLE"
  network_id  = var.network_id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }

  dynamic "host" {
    for_each = var.ha ? [0, 1] : [0]
    content {
      zone      = var.zone_ids[host.key]
      subnet_id = var.subnet_ids[host.key]
    }
  }

  maintenance_window {
    type = "ANYTIME"
  }

  deletion_protection = false
}
