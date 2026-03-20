locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

module "vpc" {
  source = "../../modules/vpc"

  region_code        = var.region_code
  project_name       = var.project_name
  cidr_block         = var.cidr_block
  azs                = var.azs
  subnet_cidrs       = var.subnet_cidrs
  pod_secondary_cidr = var.pod_secondary_cidr
  pod_subnet_cidrs   = var.pod_subnet_cidrs
  alb_cluster_name   = var.alb_cluster_name
  tags               = local.common_tags
}
