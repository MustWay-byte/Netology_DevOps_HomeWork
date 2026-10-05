resource "yandex_compute_instance_group" "lamp" {
  name               = "lamp-ig"
  folder_id          = var.folder_id
  service_account_id = data.yandex_iam_service_account.ig_sa.id

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 20
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.vpc.id
      subnet_ids         = [yandex_vpc_subnet.public.id]
      nat                = true
      security_group_ids = [yandex_vpc_security_group.lamp_sg.id]
    }

    metadata = {
      user-data = <<-EOF
        #cloud-config
        write_files:
          - path: /var/www/html/index.html
            content: |
              <!DOCTYPE html>
              <html>
              <head><title>LAMP Instance Group</title></head>
              <body>
                <h1>LAMP Instance Group работает</h1>
                <p><img src="https://mustway-2026-task2-1791180069.storage.yandexcloud.net/images.jpeg" alt="Картинка из бакета" width="500"></p>
              </body>
              </html>
            permissions: '0644'
            owner: 'www-data:www-data'
      EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name = "lamp-tg"
  }

  health_check {
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3

    http_options {
      port = 80
      path = "/"
    }
  }
}

output "lamp_ig_id" {
  value = yandex_compute_instance_group.lamp.id
}
