# ============================================================
# Network Load Balancer (подключается к TG, созданной IG)
# ============================================================
resource "yandex_lb_network_load_balancer" "lamp_nlb" {
  name      = "lamp-nlb"
  folder_id = var.folder_id

  listener {
    name        = "http-listener"
    port        = 80
    target_port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp.load_balancer.0.target_group_id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

# ============================================================
# Output
# ============================================================
output "nlb_ip" {
  value = [for l in yandex_lb_network_load_balancer.lamp_nlb.listener : [for a in l.external_address_spec : a.address][0]][0]
}
