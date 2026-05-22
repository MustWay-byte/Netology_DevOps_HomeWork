resource "null_resource" "put_secret" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -s -X POST -H "X-Vault-Token: education" -d '{"data":{"user":"student","password":"netology123"}}' http://127.0.0.1:8200/v1/secret/data/my-secret
    EOT
  }
}
