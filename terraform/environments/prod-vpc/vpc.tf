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

locals {
  eks_cluster_name = var.eks_cluster_name_override != "" ? var.eks_cluster_name_override : join("-", ["eks", var.region_code, var.project_name, "main"])

  vpc_subnet_tags = var.enable_kubernetes_subnet_tags ? {
    edge_public_2a = {
      "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
      "kubernetes.io/role/elb"                          = "1"
    }
    edge_public_2c = {
      "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
      "kubernetes.io/role/elb"                          = "1"
    }
    node_private_2a = {
      "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"                 = "1"
    }
    node_private_2c = {
      "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"                 = "1"
    }
  } : {}
}

module "vpc" {
  source = "../../modules/vpc"

  region_code        = var.region_code
  project_name       = var.project_name
  cidr_block         = var.cidr_block
  pod_secondary_cidr = var.pod_secondary_cidr
  subnets            = var.subnets
  subnet_tags        = local.vpc_subnet_tags
  tags               = local.common_tags
}
