resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.web[*],
    databases  = values(yandex_compute_instance.db),
    storage    = [yandex_compute_instance.storage]
  })
  filename = "${path.module}/inventory.ini"
}

resource "null_resource" "ansible_playbook" {
  triggers = {
    inventory_content = local_file.ansible_inventory.content
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -i ${local_file.ansible_inventory.filename} ${path.module}/test.yml"
    working_dir = path.module
  }

  depends_on = [local_file.ansible_inventory, yandex_compute_instance.storage]
}
