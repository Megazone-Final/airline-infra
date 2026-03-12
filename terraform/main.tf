locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "./modules/vpc"

  region_code                  = var.region_code
  project_name                 = var.project
  cidr_block                   = var.vpc_cidr
  azs                          = var.azs
  subnet_cidrs                 = var.subnet_cidrs
  pod_secondary_cidr           = var.pod_secondary_cidr
  pod_subnet_cidrs             = var.pod_subnet_cidrs
  alb_cluster_name             = var.alb_cluster_name
  tags                         = merge(local.common_tags, var.tags)
}
