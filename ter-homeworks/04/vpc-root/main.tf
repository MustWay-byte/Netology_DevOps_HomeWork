module "vpc_dev" {
  source   = "./vpc"
  env_name = "develop-remote"          # уникальное имя
  subnets  = [
    { zone = "ru-central1-a", cidr = "10.0.100.0/24" }   # непересекающийся CIDR
  ]
}

output "network_id" {
  value = module.vpc_dev.network_id
}

output "subnet_id" {
  value = module.vpc_dev.subnets["ru-central1-a"].id
}
