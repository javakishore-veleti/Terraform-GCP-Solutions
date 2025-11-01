module "common" {
  source = "../../modules/01-common-configs"
}

module "vpc" {
  source = "../../modules/02-common-vpc"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}