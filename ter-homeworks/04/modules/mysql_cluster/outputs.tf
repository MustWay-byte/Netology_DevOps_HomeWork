output "cluster_id" {
  description = "ID of the created MySQL cluster"
  value       = yandex_mdb_mysql_cluster.this.id
}

output "host_fqdns" {
  description = "FQDNs of the cluster hosts"
  value       = yandex_mdb_mysql_cluster.this.host[*].fqdn
}
