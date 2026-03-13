locals {
  name_prefix = "${var.project_name}-${var.environment}"
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

  enabled              = var.enable_vpc
  name                 = local.name_prefix
  cidr_block           = var.vpc_cidr
  azs                  = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  create_nat_gateway   = var.create_nat_gateway
  tags                 = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  enabled              = var.enable_ecr
  repository_names     = var.ecr_repository_names
  image_tag_mutability = var.ecr_image_tag_mutability
  scan_on_push         = var.ecr_scan_on_push
  keep_last_images     = var.ecr_keep_last_images
  tags                 = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  enabled                          = var.enable_eks
  name                             = local.name_prefix
  cluster_version                  = var.eks_cluster_version
  vpc_id                           = module.vpc.vpc_id
  subnet_ids                       = module.vpc.private_subnet_ids
  kubernetes_service_ipv4_cidr     = var.eks_service_ipv4_cidr
  endpoint_public_access           = var.eks_endpoint_public_access
  endpoint_private_access          = var.eks_endpoint_private_access
  endpoint_public_access_cidrs     = var.eks_endpoint_public_access_cidrs
  cluster_log_types                = var.eks_cluster_log_types
  cloudwatch_log_retention_in_days = var.eks_log_retention_in_days
  node_group_name                  = var.eks_node_group_name
  node_group_instance_types        = var.eks_node_instance_types
  node_group_capacity_type         = var.eks_node_capacity_type
  node_group_disk_size             = var.eks_node_disk_size
  node_group_desired_size          = var.eks_node_desired_size
  node_group_min_size              = var.eks_node_min_size
  node_group_max_size              = var.eks_node_max_size
  tags                             = local.common_tags
}

module "frontend_hosting" {
  source = "../../modules/s3"

  enabled             = var.enable_frontend_hosting
  name                = local.name_prefix
  bucket_name         = var.frontend_bucket_name != "" ? var.frontend_bucket_name : "${local.name_prefix}-frontend"
  aliases             = var.frontend_aliases
  acm_certificate_arn = var.frontend_acm_certificate_arn
  price_class         = var.frontend_price_class
  enable_spa_routing  = var.frontend_enable_spa_routing
  tags                = local.common_tags
}
