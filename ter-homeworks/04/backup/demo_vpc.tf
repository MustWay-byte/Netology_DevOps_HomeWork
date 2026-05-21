module "vpc_prod" {
  source   = "./vpc"
  env_name = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.11.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.12.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.13.0/24" },
  ]
}

module "vpc_dev" {
  source   = "./vpc"
  env_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.21.0/24" },
  ]
}
