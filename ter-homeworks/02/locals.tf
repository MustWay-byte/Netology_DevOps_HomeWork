# locals.tf
locals {
  web_name = "${var.vpc_name}-${var.vm_web_zone}-platform-web"
  db_name  = "${var.vpc_name}-${var.vm_db_zone}-platform-db"
}
